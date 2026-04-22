// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/qibla/providers/qibla_provider.dart
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/haptic_helper.dart';

enum QiblaStatus {
  loading,
  ready,
  permissionDenied,
  gpsDisabled,
  sensorUnavailable,
  error,
}

class QiblaProvider extends ChangeNotifier {
  QiblaStatus _status = QiblaStatus.loading;
  String _city = '';
  String _country = '';
  double _staticQiblaDegrees = 0;
  String _errorMessage = '';
  bool _isPermissionPermanentlyDenied = false;
  bool _alignmentHapticSent = false;

  QiblaStatus get status => _status;
  bool get isPermissionPermanentlyDenied => _isPermissionPermanentlyDenied;
  double get staticQiblaDegrees => _staticQiblaDegrees;
  String get errorMessage =>
      _errorMessage.isEmpty ? AppStrings.locationError : _errorMessage;

  String get locationLabel => AppStrings.locationDisplay(_city, _country);

  Future<void> initialize() async {
    _status = QiblaStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _status = QiblaStatus.gpsDisabled;
        notifyListeners();
        return;
      }

      PermissionStatus permissionStatus =
          await Permission.locationWhenInUse.status;

      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.locationWhenInUse.request();
      }

      if (!permissionStatus.isGranted) {
        _isPermissionPermanentlyDenied = permissionStatus.isPermanentlyDenied;
        _status = QiblaStatus.permissionDenied;
        notifyListeners();
        return;
      }

      _isPermissionPermanentlyDenied = false;

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _staticQiblaDegrees = _calculateQiblaBearing(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await _loadLocationLabel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _status = QiblaStatus.ready;
      notifyListeners();
    } catch (_) {
      _status = QiblaStatus.error;
      _errorMessage = AppStrings.locationError;
      notifyListeners();
    }
  }

  Future<void> requestPermission() async {
    final PermissionStatus status =
        await Permission.locationWhenInUse.request();
    _isPermissionPermanentlyDenied = status.isPermanentlyDenied;

    if (status.isGranted) {
      await initialize();
      return;
    }

    _status = QiblaStatus.permissionDenied;
    notifyListeners();
  }

  Future<void> openGpsSettings() async {
    await Geolocator.openLocationSettings();
    await initialize();
  }

  Future<void> openApplicationSettings() async {
    await openAppSettings();
    await initialize();
  }

  Future<void> retry() async {
    await initialize();
  }

  void handleAlignmentFeedback(bool isAligned) {
    if (isAligned && !_alignmentHapticSent) {
      _alignmentHapticSent = true;
      HapticHelper.gentle();
      return;
    }

    if (!isAligned) {
      _alignmentHapticSent = false;
    }
  }

  String qiblaDegreesText(double degrees) {
    return AppStrings.qiblaDegreesText(degrees, cardinalDirection(degrees));
  }

  String cardinalDirection(double degrees) {
    final double normalized = (degrees + 360) % 360;

    if (normalized >= 337.5 || normalized < 22.5) {
      return AppStrings.directionNorth;
    }
    if (normalized >= 22.5 && normalized < 67.5) {
      return AppStrings.directionNorthEast;
    }
    if (normalized >= 67.5 && normalized < 112.5) {
      return AppStrings.directionEast;
    }
    if (normalized >= 112.5 && normalized < 157.5) {
      return AppStrings.directionSouthEast;
    }
    if (normalized >= 157.5 && normalized < 202.5) {
      return AppStrings.directionSouth;
    }
    if (normalized >= 202.5 && normalized < 247.5) {
      return AppStrings.directionSouthWest;
    }
    if (normalized >= 247.5 && normalized < 292.5) {
      return AppStrings.directionWest;
    }

    return AppStrings.directionNorthWest;
  }

  Future<void> _loadLocationLabel({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final List<Placemark> marks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (marks.isEmpty) {
        _city = '';
        _country = '';
        return;
      }

      final Placemark mark = marks.first;
      _city = (mark.locality ?? mark.subAdministrativeArea ?? '').trim();
      _country = (mark.country ?? '').trim();
    } catch (_) {
      _city = '';
      _country = '';
    }
  }

  double _calculateQiblaBearing({
    required double latitude,
    required double longitude,
  }) {
    const double kaabaLat = 21.4225;
    const double kaabaLon = 39.8262;

    final double latRad = _degreesToRadians(latitude);
    final double lonRad = _degreesToRadians(longitude);
    final double kaabaLatRad = _degreesToRadians(kaabaLat);
    final double kaabaLonRad = _degreesToRadians(kaabaLon);

    final double deltaLon = kaabaLonRad - lonRad;

    final double y = math.sin(deltaLon);
    final double x = (math.cos(latRad) * math.tan(kaabaLatRad)) -
        (math.sin(latRad) * math.cos(deltaLon));

    final double bearingRad = math.atan2(y, x);
    final double bearingDeg = _radiansToDegrees(bearingRad);
    return (bearingDeg + 360) % 360;
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;
  double _radiansToDegrees(double radians) => radians * 180 / math.pi;
}
