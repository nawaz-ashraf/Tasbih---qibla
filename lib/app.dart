// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/app.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/qibla/screens/qibla_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/tasbih/screens/tasbih_screen.dart';
import 'shared/widgets/neu_bottom_nav.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex == index) {
      return;
    }

    _currentIndex = index;
    notifyListeners();
  }
}

class TasbihQiblaApp extends StatelessWidget {
  const TasbihQiblaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider themeProvider, _) {
        return NeumorphicApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const _SplashGate(),
        );
      },
    );
  }
}

class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  late final Future<void> _splashDelayFuture;

  @override
  void initState() {
    super.initState();
    _splashDelayFuture = Future<void>.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _splashDelayFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _SplashScreen();
        }

        return ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
          child: const _MainHomeShell(),
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return NeumorphicBackground(
      child: Center(
        child: FadeIn(
          duration: const Duration(milliseconds: 900),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 6,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(24)),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  AppStrings.splashIconAsset,
                  width: 58,
                  height: 58,
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.appName,
                  style: GoogleFonts.amiri(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.appTagline,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary(isDark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainHomeShell extends StatelessWidget {
  const _MainHomeShell();

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navProvider = context.watch<NavigationProvider>();

    return NeumorphicBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: IndexedStack(
          index: navProvider.currentIndex,
          children: const <Widget>[
            TasbihScreen(),
            QiblaScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: NeuBottomNav(
            currentIndex: navProvider.currentIndex,
            onChanged: navProvider.setIndex,
          ),
        ),
      ),
    );
  }
}
