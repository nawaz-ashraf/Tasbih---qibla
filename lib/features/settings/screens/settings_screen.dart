import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_toggle_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = context.watch<SettingsProvider>();
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        title: Text(
          AppStrings.settingsTitle,
          style: GoogleFonts.amiri(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(isDark),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _SummaryCard(isDark: isDark),
              const SizedBox(height: 16),
              _SectionHeader(label: AppStrings.tasbihSettings),
              SettingsToggleRow(
                icon: Icons.vibration_rounded,
                label: AppStrings.vibration,
                subtitle: 'Haptic feedback on each count',
                value: settings.vibrationEnabled,
                onToggle: settings.toggleVibration,
              ),
              SettingsToggleRow(
                icon: Icons.volume_up_rounded,
                label: AppStrings.soundOnTap,
                subtitle: 'Play click on each tap',
                value: settings.soundEnabled,
                onToggle: settings.toggleSound,
              ),
              SettingsToggleRow(
                icon: Icons.record_voice_over_rounded,
                label: AppStrings.speech,
                subtitle: 'Read selected dhikr aloud',
                value: settings.speechEnabled,
                onToggle: settings.toggleSpeech,
              ),
              SettingsToggleRow(
                icon: Icons.lightbulb_circle_rounded,
                label: AppStrings.keepScreenOn,
                subtitle: 'Prevent screen sleep while using app',
                value: settings.keepScreenOn,
                onToggle: settings.toggleKeepScreen,
              ),
              const SizedBox(height: 10),
              _SectionHeader(label: AppStrings.appearance),
              SettingsToggleRow(
                icon: Icons.nightlight_round,
                label: AppStrings.nightMode,
                subtitle: 'Switch between light and dark themes',
                value: settings.nightMode,
                onToggle: () => settings.toggleNightMode(context),
              ),
              const SizedBox(height: 10),
              _SectionHeader(label: AppStrings.about),
              _AboutCard(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 5,
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        color: NeumorphicTheme.baseColor(context),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.appName,
            style: GoogleFonts.amiri(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Text(
                'Version ${AppStrings.appVersion}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGreen,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.active,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 2),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          letterSpacing: 1,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary(isDark),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        color: NeumorphicTheme.baseColor(context),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'App: ${AppStrings.appName}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Version: ${AppStrings.appVersion}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.developerNote,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
