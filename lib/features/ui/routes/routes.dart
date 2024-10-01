import 'package:aurudu_nakath/features/ui/Compass/compass.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_screen.dart';
import 'package:aurudu_nakath/features/ui/aurudu_nakath/presentation/pages/main_screen.dart';
import 'package:aurudu_nakath/features/ui/errors/error_screen.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/chat_view.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/helagptpro.dart';
import 'package:aurudu_nakath/features/ui/help/presentation/pages/help_screen.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/other_screen.dart';
import 'package:aurudu_nakath/features/ui/intro_screens/onboarding_screen/onboarding_screen.dart';
import 'package:aurudu_nakath/features/ui/lagna_palapala/presentation/pages/lagna_palapala_screen.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/litha_main.dart';
import 'package:aurudu_nakath/features/ui/rahu_kalaya/presentation/pages/raahu_kaalaya_page.dart';
import 'package:aurudu_nakath/features/ui/settings/presentation/pages/settings_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AppRoutes {
  static FirebaseAnalytics analytics =
      FirebaseAnalytics.instance; // Use named constructor

  static const String home = '/';
  static const String help = '/help';
  static const String onboarding = '/onboarding';
  static const String aurudu_nakath = '/aurudu_nakath';
  static const String lagna = '/lagna';
  static const String dashboard = '/dashboard';
  static const String rahu_kalaya = '/rahu_kalaya';
  static const String helagptPro = '/helagptPro';
  static const String malimawa = '/malimawa';
  static const String setting = '/setting';
  static const String other_tools = '/other_tools';
  static const String lagna_palapala = '/lagna_palapala';
  static const String litha = '/litha';
  static const String helagptnormless = '/helagptnormless';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Log Firebase Analytics event for screen view
    analytics.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': settings.name.toString()},
    );

    switch (settings.name) {
      case help:
        return _buildPageWithSlideTransition(
            HelpScreen(), Offset(1, 0)); // Slide from right
      case litha:
        return _buildPageWithSlideTransition(
            LithaMainScreen(), Offset(1, 0)); // Slide from right
      case login:
        return _buildPageWithSlideTransition(
            LoginScreen(), Offset(1, 0)); // Slide from right
      case other_tools:
        return _buildPageWithSlideTransition(
            OtherTools(), Offset(1, 0)); // Slide from right
      case helagptPro:
        return _buildPageWithSlideTransition(
            HelaGPT_PRO(), Offset(1, 0)); // Slide from right
      case helagptnormless:
        return _buildPageWithSlideTransition(
            ChatView(), Offset(1, 0)); // Slide from right
      case setting:
        return _buildPageWithSlideTransition(
            SettingsPage(), Offset(1, 0)); // Slide from right
      case malimawa:
        return _buildPageWithSlideTransition(
            Compass(), Offset(1, 0)); // Slide from right
      case onboarding:
        return _buildPageWithSlideTransition(
            Onboarding(), Offset(1, 0)); // Slide from right
      case aurudu_nakath:
        return _buildPageWithSlideTransition(
            AuruduNakath(), Offset(1, 0)); // Slide from right
      case lagna:
        return _buildPageWithSlideTransition(
            LagnaPalapala(), Offset(1, 0)); // Slide from right
      case rahu_kalaya:
        return _buildPageWithSlideTransition(
            RaahuKaalaya(), Offset(1, 0)); // Slide from right
      case dashboard:
        return _buildPageWithSlideTransition(
            DashBoard(), Offset(1, 0)); // Slide from right
      default:
        return _buildPageWithSlideTransition(
            ErrorScreen(), Offset(1, 0)); // Fallback in case of undefined route
    }
  }

  // Slide transition route
  static PageRouteBuilder _buildPageWithSlideTransition(
      Widget page, Offset beginOffset) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var tween = Tween(begin: beginOffset, end: Offset.zero)
            .chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }
}
