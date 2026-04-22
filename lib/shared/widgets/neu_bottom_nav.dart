// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/shared/widgets/neu_bottom_nav.dart
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class NeuBottomNav extends StatelessWidget {
  const NeuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const List<_NavItem> items = <_NavItem>[
      _NavItem(icon: Icons.bubble_chart_rounded, label: AppStrings.tabTasbih),
      _NavItem(icon: Icons.explore_rounded, label: AppStrings.tabQibla),
      _NavItem(icon: Icons.settings_rounded, label: AppStrings.tabSettings),
    ];

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 6,
        intensity: NeumorphicTheme.currentTheme(context).intensity,
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: List<Widget>.generate(items.length, (int index) {
          final bool selected = currentIndex == index;
          final bool isDark = NeumorphicTheme.isUsingDark(context);

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: selected ? -3 : 3,
                    shape: selected
                        ? NeumorphicShape.concave
                        : NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(18),
                    ),
                    color: NeumorphicTheme.baseColor(context),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      vertical: selected ? 8 : 10,
                      horizontal: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          items[index].icon,
                          color: selected
                              ? AppColors.accentGreen
                              : AppColors.inactive(isDark),
                          size: 22,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: selected
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    items[index].label,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentGreen,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
