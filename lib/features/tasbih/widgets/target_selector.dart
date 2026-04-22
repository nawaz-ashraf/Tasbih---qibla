import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/tasbih_provider.dart';

class TargetSelector extends StatelessWidget {
  const TargetSelector({
    super.key,
    required this.selectedTarget,
    required this.isCustomTarget,
    required this.onSelected,
  });

  final int selectedTarget;
  final bool isCustomTarget;
  final ValueChanged<int> onSelected;

  static const List<Map<String, Object>> _targets = <Map<String, Object>>[
    <String, Object>{'label': '33', 'value': 33, 'isInfinity': false},
    <String, Object>{'label': '99', 'value': 99, 'isInfinity': false},
    <String, Object>{'label': '100', 'value': 100, 'isInfinity': false},
    <String, Object>{'label': '∞', 'value': 0, 'isInfinity': true},
    <String, Object>{'label': 'custom', 'value': -1, 'isInfinity': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _targets.map((Map<String, Object> item) {
        final int targetValue = item['value']! as int;
        final bool isDark = NeumorphicTheme.isUsingDark(context);
        final bool selected = targetValue == -1
            ? isCustomTarget
            : (!isCustomTarget && selectedTarget == targetValue);

        final String label = targetValue == -1
            ? (isCustomTarget ? '✎ $selectedTarget' : '✎ Custom')
            : (targetValue == 0 ? AppStrings.infinitySymbol : '$targetValue');

        return GestureDetector(
          onTap: () {
            if (targetValue == -1) {
              _showCustomTargetDialog(context);
              return;
            }
            onSelected(targetValue);
          },
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 150),
            offset: selected ? const Offset(0, -0.03) : Offset.zero,
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: selected ? -4 : 3,
                shape:
                    selected ? NeumorphicShape.concave : NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(22),
                ),
                color: selected
                    ? AppColors.accentGreen.withOpacity(isDark ? 0.18 : 0.20)
                    : NeumorphicTheme.baseColor(context),
                border: selected
                    ? const NeumorphicBorder(
                        color: AppColors.accentGreen,
                        width: 1.4,
                      )
                    : const NeumorphicBorder.none(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.accentGreen
                      : AppColors.textSecondary(isDark),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showCustomTargetDialog(BuildContext context) async {
    final int? customTarget = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _CustomTargetDialog(),
    );

    if (customTarget == null || !context.mounted) {
      return;
    }

    // Let the dialog route fully settle before notifying listeners.
    await Future<void>.delayed(Duration.zero);

    if (!context.mounted) {
      return;
    }

    final TasbihProvider provider = context.read<TasbihProvider>();
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );

    await provider.setCustomTarget(customTarget);

    if (!context.mounted) {
      return;
    }

    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${AppStrings.targetSetPrefix} $customTarget ✓'),
          backgroundColor: const Color(0xFF4CAF82),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class _CustomTargetDialog extends StatefulWidget {
  const _CustomTargetDialog();

  @override
  State<_CustomTargetDialog> createState() => _CustomTargetDialogState();
}

class _CustomTargetDialogState extends State<_CustomTargetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 6,
          color: NeumorphicTheme.baseColor(context),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.setCustomTarget,
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicTheme.defaultTextColor(context),
                ),
              ),
              const SizedBox(height: 20),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -3,
                  color: NeumorphicTheme.baseColor(context),
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 5,
                    decoration: const InputDecoration(
                      hintText: AppStrings.customTargetHint,
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: NeumorphicTheme.defaultTextColor(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: const NeumorphicStyle(depth: 3),
                      child: Center(
                        child: Text(
                          AppStrings.cancel,
                          style: TextStyle(
                            color: NeumorphicTheme.defaultTextColor(
                              context,
                            ).withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {
                        final int? value =
                            int.tryParse(_controller.text.trim());
                        if (value != null && value > 0) {
                          Navigator.of(context).pop(value);
                          return;
                        }

                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.invalidNumber),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: const NeumorphicStyle(
                        depth: 3,
                        color: Color(0xFF4CAF82),
                      ),
                      child: const Center(
                        child: Text(
                          'Set Target',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
