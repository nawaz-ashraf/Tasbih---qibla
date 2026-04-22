// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/tasbih/widgets/dhikr_selector.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dhikr_data.dart';

class DhikrSelector extends StatelessWidget {
  const DhikrSelector({
    super.key,
    required this.selectedDhikr,
    required this.onSelected,
  });

  final DhikrModel selectedDhikr;
  final ValueChanged<DhikrModel> onSelected;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final DhikrModel dhikr = dhikrList[index];
          final bool selected = selectedDhikr.id == dhikr.id;

          return FadeInUp(
            duration: Duration(milliseconds: 200 + (index * 45)),
            child: GestureDetector(
              onTap: () => onSelected(dhikr),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: selected ? -4 : 4,
                    shape: selected
                        ? NeumorphicShape.concave
                        : NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(20),
                    ),
                    color: NeumorphicTheme.baseColor(context),
                    border: NeumorphicBorder(
                      color: selected
                          ? AppColors.accentGreen
                          : AppColors.transparent,
                      width: selected ? 1.4 : 0,
                    ),
                  ),
                  child: SizedBox(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dhikr.arabic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.amiri(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColors.accentGreen
                                  : AppColors.textPrimary(isDark),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dhikr.transliteration,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: dhikrList.length,
      ),
    );
  }
}
