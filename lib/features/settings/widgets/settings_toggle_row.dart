import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onToggle,
    this.subtitle = '',
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final VoidCallback onToggle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final bool isLight = !NeumorphicTheme.isUsingDark(context);

    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 6),
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.6,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        color: NeumorphicTheme.baseColor(context),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Neumorphic(
              style: NeumorphicStyle(
                depth: -3,
                boxShape: const NeumorphicBoxShape.circle(),
                color: NeumorphicTheme.baseColor(context),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? const Color(0xFF4CAF82),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: NeumorphicTheme.defaultTextColor(context),
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: NeumorphicTheme.defaultTextColor(
                          context,
                        ).withOpacity(0.5),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 68,
                height: 32,
                decoration: BoxDecoration(
                  color: value
                      ? const Color(0xFF4CAF82)
                      : (isLight
                          ? const Color(0xFFD0D3DC)
                          : const Color(0xFF2E3347)),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: value
                      ? <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFF4CAF82).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                          BoxShadow(
                            color:
                                Colors.white.withOpacity(isLight ? 0.7 : 0.05),
                            blurRadius: 6,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    value ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: value
                          ? Colors.white
                          : NeumorphicTheme.defaultTextColor(
                              context,
                            ).withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
