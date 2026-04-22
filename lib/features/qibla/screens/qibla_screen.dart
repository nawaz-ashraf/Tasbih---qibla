import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/theme_toggle_btn.dart';
import '../providers/qibla_provider.dart';
import '../services/qibla_calculator.dart';
import '../widgets/location_error_widget.dart';
import '../widgets/qibla_compass.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  QiblaCalculatorService? _qiblaService;
  bool _serviceLoading = false;
  bool _serviceReady = false;
  String? _serviceError;
  bool _serviceInitQueued = false;

  final List<_AngleSample> _angleSamples = <_AngleSample>[];
  DateTime? _lastUnstableAt;

  @override
  void dispose() {
    _disposeQiblaService();
    super.dispose();
  }

  void _disposeQiblaService() {
    _qiblaService?.dispose();
    _qiblaService = null;
    _serviceReady = false;
    _serviceLoading = false;
    _serviceError = null;
    _serviceInitQueued = false;
    _angleSamples.clear();
    _lastUnstableAt = null;
  }

  Future<void> _ensureQiblaServiceStarted() async {
    if (_serviceReady || _serviceLoading) {
      return;
    }

    setState(() {
      _serviceInitQueued = false;
      _serviceLoading = true;
      _serviceError = null;
    });

    final QiblaCalculatorService service = QiblaCalculatorService();

    try {
      await service.init();
      if (!mounted) {
        service.dispose();
        return;
      }

      setState(() {
        _qiblaService = service;
        _serviceReady = true;
        _serviceLoading = false;
        _serviceInitQueued = false;
      });
    } catch (error) {
      service.dispose();
      if (!mounted) {
        return;
      }

      setState(() {
        _serviceReady = false;
        _serviceLoading = false;
        _serviceError = error.toString();
        _serviceInitQueued = false;
      });
    }
  }

  Future<void> _retryAll() async {
    _disposeQiblaService();
    await context.read<QiblaProvider>().retry();
    if (!mounted) {
      return;
    }
    await _ensureQiblaServiceStarted();
  }

  bool _isCalibrationUnstable(double needleAngle) {
    final DateTime now = DateTime.now();

    _angleSamples.add(_AngleSample(now, needleAngle));
    _angleSamples.removeWhere(
      (_AngleSample sample) =>
          now.difference(sample.time) > const Duration(seconds: 1),
    );

    if (_angleSamples.length < 2) {
      final bool stillShowing = _lastUnstableAt != null &&
          now.difference(_lastUnstableAt!) < const Duration(seconds: 5);
      return stillShowing;
    }

    final double baseAngle = _angleSamples.first.angle;
    double maxDelta = 0;

    for (final _AngleSample sample in _angleSamples) {
      final double delta = _angleDelta(sample.angle, baseAngle).abs();
      if (delta > maxDelta) {
        maxDelta = delta;
      }
    }

    final bool unstable = maxDelta > 20;
    if (unstable) {
      _lastUnstableAt = now;
      return true;
    }

    if (_lastUnstableAt == null) {
      return false;
    }

    return now.difference(_lastUnstableAt!) < const Duration(seconds: 5);
  }

  double _angleDelta(double a, double b) {
    return ((a - b + 540) % 360) - 180;
  }

  @override
  Widget build(BuildContext context) {
    final QiblaProvider provider = context.watch<QiblaProvider>();
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text(
          AppStrings.qiblaTitle,
          style: GoogleFonts.amiri(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(isDark),
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: SafeArea(top: false, child: _buildBody(context, provider)),
    );
  }

  Widget _buildBody(BuildContext context, QiblaProvider provider) {
    switch (provider.status) {
      case QiblaStatus.loading:
        return _buildLoadingState(context);
      case QiblaStatus.permissionDenied:
        return LocationErrorWidget(
          icon: Icons.location_disabled_rounded,
          message: provider.isPermissionPermanentlyDenied
              ? AppStrings.locationPermanentlyDenied
              : AppStrings.locationPermissionRequired,
          actionLabel: provider.isPermissionPermanentlyDenied
              ? AppStrings.openSettings
              : AppStrings.grantPermission,
          onAction: provider.isPermissionPermanentlyDenied
              ? provider.openApplicationSettings
              : provider.requestPermission,
        );
      case QiblaStatus.gpsDisabled:
        return LocationErrorWidget(
          icon: Icons.gps_off_rounded,
          message: AppStrings.gpsDisabled,
          actionLabel: AppStrings.openSettings,
          onAction: provider.openGpsSettings,
        );
      case QiblaStatus.error:
        return LocationErrorWidget(
          icon: Icons.error_outline_rounded,
          message: provider.errorMessage,
          actionLabel: AppStrings.retry,
          onAction: _retryAll,
        );
      case QiblaStatus.sensorUnavailable:
        return LocationErrorWidget(
          icon: Icons.explore_off_rounded,
          message: AppStrings.compassUnavailable,
          actionLabel: AppStrings.retry,
          onAction: _retryAll,
        );
      case QiblaStatus.ready:
        return _buildReadyState(provider);
    }
  }

  Widget _buildReadyState(QiblaProvider provider) {
    if (!_serviceReady &&
        !_serviceLoading &&
        _serviceError == null &&
        !_serviceInitQueued) {
      _serviceInitQueued = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _ensureQiblaServiceStarted();
      });
    }

    if (_serviceLoading) {
      return _buildLoadingState(context);
    }

    if (_serviceError != null) {
      return LocationErrorWidget(
        icon: Icons.explore_off_rounded,
        message: _serviceError!,
        actionLabel: AppStrings.retry,
        onAction: _retryAll,
      );
    }

    final QiblaCalculatorService? service = _qiblaService;
    if (service == null) {
      return _buildLoadingState(context);
    }

    return StreamBuilder<QiblaReading>(
      stream: service.stream,
      builder: (BuildContext context, AsyncSnapshot<QiblaReading> snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingState(context);
        }

        final QiblaReading reading = snapshot.data!;
        final bool showCalibrationWarning = _isCalibrationUnstable(
          reading.needleAngle,
        );

        provider.handleAlignmentFeedback(reading.isFacingQibla);

        return _QiblaContent(
          locationLabel: provider.locationLabel,
          qiblaText: provider.qiblaDegreesText(reading.qiblaBearing),
          reading: reading,
          showCalibrationWarning: showCalibrationWarning,
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return Center(
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          color: NeumorphicTheme.baseColor(context),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppStrings.waitingCompass,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QiblaContent extends StatelessWidget {
  const _QiblaContent({
    required this.locationLabel,
    required this.qiblaText,
    required this.reading,
    required this.showCalibrationWarning,
  });

  final String locationLabel;
  final String qiblaText;
  final QiblaReading reading;
  final bool showCalibrationWarning;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SlideInDown(
            duration: const Duration(milliseconds: 250),
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 4,
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(20),
                ),
                color: NeumorphicTheme.baseColor(context),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.location_pin,
                        color: AppColors.locationPin,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          locationLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    qiblaText,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showCalibrationWarning)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 3,
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(14),
                  ),
                  color: const Color(0xFFF4D79A),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  AppStrings.calibrationHint,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6D4C00),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Center(child: QiblaCompass(reading: reading)),
          const SizedBox(height: 20),
          Neumorphic(
            style: NeumorphicStyle(
              depth: reading.isFacingQibla ? -3 : 3,
              shape: reading.isFacingQibla
                  ? NeumorphicShape.concave
                  : NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18)),
              color: reading.isFacingQibla
                  ? AppColors.accentGreen
                  : NeumorphicTheme.baseColor(context),
            ),
            padding: const EdgeInsets.all(14),
            child: Text(
              reading.isFacingQibla
                  ? AppStrings.facingQibla
                  : AppStrings.rotateToQibla,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: reading.isFacingQibla
                    ? AppColors.white
                    : AppColors.textPrimary(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AngleSample {
  const _AngleSample(this.time, this.angle);

  final DateTime time;
  final double angle;
}
