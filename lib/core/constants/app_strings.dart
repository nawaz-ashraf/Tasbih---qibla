// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/core/constants/app_strings.dart
class AppStrings {
  AppStrings._();

  static const String appName = 'Tasbih & Qibla';
  static const String appTagline = 'Your Daily Islamic Companion';
  static const String tasbihTitle = 'Tasbih';
  static const String qiblaTitle = 'Qibla Finder';

  static const String tabTasbih = 'Tasbih';
  static const String tabQibla = 'Qibla';
  static const String tabSettings = 'Settings';

  static const String settingsTitle = 'Settings';
  static const String setCustomTarget = 'Set Custom Target';
  static const String customTargetHint = 'Enter number (e.g. 500)';
  static const String targetSetPrefix = 'Target set to';
  static const String invalidNumber = 'Please enter a valid number';
  static const String appVersion = '1.0.0';
  static const String active = 'Active';
  static const String tasbihSettings = 'TASBIH SETTINGS';
  static const String appearance = 'APPEARANCE';
  static const String about = 'ABOUT';
  static const String vibration = 'Vibration';
  static const String soundOnTap = 'Sound on tap';
  static const String speech = 'Speech (TTS)';
  static const String keepScreenOn = 'Keep Screen On';
  static const String nightMode = 'Night Mode';
  static const String developerNote =
      'Built with calm Neumorphic design for focused daily dhikr and accurate Qibla guidance.';
  static const String calibrationHint =
      '⚠ Move device in a figure-8 to calibrate compass';

  static const String reset = 'Reset';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';

  static const String resetDialogTitle = 'Reset Counter';
  static const String resetDialogMessage =
      'Are you sure you want to reset your Tasbih count?';

  static const String targetReachedMessage = 'MashaAllah! Target Reached 🤲';

  static const String transliterationLabel = 'Transliteration';
  static const String meaningLabel = 'Meaning';
  static const String targetLabel = 'Target';

  static const String infinitySymbol = '∞';

  static const String locationPermissionRequired =
      'Location permission required';
  static const String locationPermanentlyDenied =
      'Location permission is permanently denied';
  static const String gpsDisabled = 'Please enable GPS';
  static const String openSettings = 'Open Settings';
  static const String grantPermission = 'Grant Permission';
  static const String compassUnavailable = 'Compass sensor is not available';
  static const String fallbackDirectionHint =
      'Showing static Qibla direction from your location';
  static const String waitingCompass = 'Waiting for compass data...';
  static const String locationUnknown = 'Locating...';
  static const String locationError = 'Unable to access location right now';

  static const String facingQibla = '✓ You are facing the Qibla';
  static const String rotateToQibla = 'Rotate to find Qibla direction';

  static const String directionNorth = 'N';
  static const String directionNorthEast = 'NE';
  static const String directionEast = 'E';
  static const String directionSouthEast = 'SE';
  static const String directionSouth = 'S';
  static const String directionSouthWest = 'SW';
  static const String directionWest = 'W';
  static const String directionNorthWest = 'NW';

  static const String kaabaEmoji = '🕋';
  static const String splashIconAsset = 'assets/icons/kaaba.svg';

  static String targetText(int target) =>
      '/ ${target <= 0 ? infinitySymbol : target.toString()}';

  static String locationDisplay(String city, String country) {
    final String safeCity = city.trim();
    final String safeCountry = country.trim();

    if (safeCity.isEmpty && safeCountry.isEmpty) {
      return locationUnknown;
    }
    if (safeCity.isEmpty) {
      return safeCountry;
    }
    if (safeCountry.isEmpty) {
      return safeCity;
    }

    return '$safeCity, $safeCountry';
  }

  static String qiblaDegreesText(double degrees, String direction) =>
      'Qibla: ${degrees.toStringAsFixed(1)}° $direction';

  static String qiblaDegreesOnly(double degrees) =>
      'Qibla: ${degrees.toStringAsFixed(1)}°';
}
