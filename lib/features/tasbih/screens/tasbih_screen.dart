// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/tasbih/screens/tasbih_screen.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/dhikr_data.dart';
import '../../../core/services/ad_service.dart';
import '../../../shared/widgets/theme_toggle_btn.dart';
import '../providers/tasbih_provider.dart';
import '../widgets/dhikr_selector.dart';
import '../widgets/progress_arc.dart';
import '../widgets/reset_button.dart';
import '../widgets/target_selector.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  bool _resetScheduled = false;

  void _handleTargetReached(TasbihProvider provider) {
    if (!provider.targetReached || _resetScheduled) {
      return;
    }

    _resetScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final bool isDark = NeumorphicTheme.isUsingDark(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.targetReachedMessage,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            backgroundColor:
                isDark ? AppColors.darkShadowDark : AppColors.snackBarBg,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 1200),
          ),
        );

      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) {
        return;
      }

      final TasbihProvider freshProvider = context.read<TasbihProvider>();
      await freshProvider.reset();
      freshProvider.clearTargetReached();
      _resetScheduled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text(
          AppStrings.tasbihTitle,
          style: GoogleFonts.amiri(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(NeumorphicTheme.isUsingDark(context)),
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTasbihContent(context)),
          SafeArea(
            top: false,
            child: Container(
              alignment: Alignment.center,
              color: NeumorphicTheme.baseColor(context),
              child: AnimatedBuilder(
                animation: adService,
                builder: (_, __) => adService.buildBannerWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihContent(BuildContext context) {
    final TasbihProvider tasbihProvider = context.watch<TasbihProvider>();
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    _handleTargetReached(tasbihProvider);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: FadeIn(
                key: ValueKey<int>(tasbihProvider.selectedDhikr.id),
                child: _DhikrInfoCard(dhikr: tasbihProvider.selectedDhikr),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ProgressArc(
                progress: tasbihProvider.progress,
                count: tasbihProvider.count,
                target: tasbihProvider.target,
                flashGoal: tasbihProvider.targetReached,
                onTap: () {
                  context.read<TasbihProvider>().increment();
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.targetLabel,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(isDark),
              ),
            ),
            const SizedBox(height: 12),
            TargetSelector(
              selectedTarget: tasbihProvider.target,
              isCustomTarget: tasbihProvider.isCustomTarget,
              onSelected: (int newTarget) {
                context.read<TasbihProvider>().setTarget(newTarget);
              },
            ),
            const SizedBox(height: 20),
            DhikrSelector(
              selectedDhikr: tasbihProvider.selectedDhikr,
              onSelected: (DhikrModel dhikr) {
                context.read<TasbihProvider>().setDhikr(dhikr);
              },
            ),
            const SizedBox(height: 20),
            ResetButton(
              onConfirm: () => context.read<TasbihProvider>().reset(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DhikrInfoCard extends StatelessWidget {
  const _DhikrInfoCard({required this.dhikr});

  final DhikrModel dhikr;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return SlideInUp(
      duration: const Duration(milliseconds: 220),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          color: NeumorphicTheme.baseColor(context),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              dhikr.arabic,
              style: GoogleFonts.amiri(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppStrings.transliterationLabel}: ${dhikr.transliteration}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(isDark),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppStrings.meaningLabel}: ${dhikr.meaning}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
