import 'dart:async';
import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class QiblaReading {
  const QiblaReading({
    required this.qiblaBearing,
    required this.deviceHeading,
    required this.needleAngle,
    required this.isFacingQibla,
  });

  final double qiblaBearing;
  final double deviceHeading;
  final double needleAngle;
  final bool isFacingQibla;
}

class QiblaCalculatorService {
  static const double _alpha = 0.15;

  List<double> _accel = <double>[0, 0, 0];
  List<double> _magnet = <double>[0, 0, 0];
  final List<double> _gravity = <double>[0, 0, 0];
  final List<double> _filteredMagnet = <double>[0, 0, 0];

  double? _qiblaBearing;

  final StreamController<QiblaReading> _controller =
      StreamController<QiblaReading>.broadcast();

  Stream<QiblaReading> get stream => _controller.stream;

  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magnetSub;

  Future<void> init() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final Coordinates coordinates = Coordinates(
      position.latitude,
      position.longitude,
    );

    _qiblaBearing = (Qibla(coordinates).direction + 360) % 360;

    _accelSub = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 40),
    ).listen((AccelerometerEvent event) {
      _accel = <double>[event.x, event.y, event.z];
      _gravity[0] = _alpha * _accel[0] + (1 - _alpha) * _gravity[0];
      _gravity[1] = _alpha * _accel[1] + (1 - _alpha) * _gravity[1];
      _gravity[2] = _alpha * _accel[2] + (1 - _alpha) * _gravity[2];
      _compute();
    });

    _magnetSub = magnetometerEventStream(
      samplingPeriod: const Duration(milliseconds: 40),
    ).listen((MagnetometerEvent event) {
      _magnet = <double>[event.x, event.y, event.z];
      _filteredMagnet[0] =
          _alpha * _magnet[0] + (1 - _alpha) * _filteredMagnet[0];
      _filteredMagnet[1] =
          _alpha * _magnet[1] + (1 - _alpha) * _filteredMagnet[1];
      _filteredMagnet[2] =
          _alpha * _magnet[2] + (1 - _alpha) * _filteredMagnet[2];
      _compute();
    });
  }

  void _compute() {
    if (_qiblaBearing == null) {
      return;
    }

    final double ax = _gravity[0];
    final double ay = _gravity[1];
    final double az = _gravity[2];

    final double mx = _filteredMagnet[0];
    final double my = _filteredMagnet[1];
    final double mz = _filteredMagnet[2];

    final double normA = math.sqrt(ax * ax + ay * ay + az * az);
    if (normA == 0) {
      return;
    }

    double hx = my * az - mz * ay;
    double hy = mz * ax - mx * az;
    double hz = mx * ay - my * ax;

    final double normH = math.sqrt(hx * hx + hy * hy + hz * hz);
    if (normH < 0.1) {
      return;
    }

    hx /= normH;
    hy /= normH;
    hz /= normH;

    final double aX = ax / normA;
    final double aY = ay / normA;
    final double aZ = az / normA;

    final double mX = aY * hz - aZ * hy;
    final double mY = aZ * hx - aX * hz;
    final double mZ = aX * hy - aY * hx;

    final List<double> rotation = List<double>.filled(9, 0)
      ..[0] = hx
      ..[1] = hy
      ..[2] = hz
      ..[3] = mX
      ..[4] = mY
      ..[5] = mZ
      ..[6] = aX
      ..[7] = aY
      ..[8] = aZ;

    final double azimuthRad = math.atan2(rotation[1], rotation[4]);
    final double deviceHeading = (azimuthRad * (180 / math.pi) + 360) % 360;

    final double needleAngle = (_qiblaBearing! - deviceHeading + 360) % 360;
    final double diff = (needleAngle + 180) % 360 - 180;
    final bool isFacingQibla = diff.abs() <= 5;

    if (_controller.isClosed) {
      return;
    }

    _controller.add(
      QiblaReading(
        qiblaBearing: _qiblaBearing!,
        deviceHeading: deviceHeading,
        needleAngle: needleAngle,
        isFacingQibla: isFacingQibla,
      ),
    );
  }

  void dispose() {
    _accelSub?.cancel();
    _magnetSub?.cancel();
    _controller.close();
  }
}
