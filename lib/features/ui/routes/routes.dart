import 'package:aurudu_nakath/features/ui/lagna_palapala/presentation/pages/lagna_palapala_screen.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/litha_main.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/Compass/compass.dart';
import 'package:aurudu_nakath/features/ui/aurudu_nakath/presentation/pages/main_screen.dart';
import 'package:aurudu_nakath/features/ui/errors/error_screen.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/chat_view.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/other_screen.dart';
import 'package:aurudu_nakath/features/ui/rahu_kalaya/presentation/pages/raahu_kaalaya_page.dart';
import 'package:aurudu_nakath/features/ui/settings/presentation/pages/settings_page.dart';
import 'package:aurudu_nakath/main.dart';

import 'package:aurudu_nakath/features/ui/help/presentation/pages/help_screen.dart';
import 'package:aurudu_nakath/features/ui/intro_screens/onboarding_screen/onboarding_screen.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';

class AppRoutes {
  static const String home = '/';
  static const String help = '/help';
  static const String onboarding = '/onboarding';
  static const String aurudu_nakath = '/aurudu_nakath';
  static const String lagna = '/lagna';
  static const String dashboard = '/dashboard';
  static const String rahu_kalaya = '/rahu_kalaya';
  static const String hela_gpt = '/hela_gpt';
  static const String malimawa = '/malimawa';
  static const String setting = '/setting';
  static const String other_tools = '/other_tools';
  static const String lagna_palapala = '/lagna_palapala';
  static const String litha = '/litha';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case help:
        return _createPageRoute(HelpScreen());

      case litha:
        return _createPageRoute(LithaMainScreen());
      case other_tools:
        return _createPageRoute(OtherTools());

      case setting:
        return _createPageRoute(SettingsPage());
      case malimawa:
        return _createPageRoute(Compass());
      case hela_gpt:
        return _createPageRoute(ChatView());
      case onboarding:
        return _createPageRoute(Onboarding());
      case aurudu_nakath:
        return _createPageRoute(AuruduNakath());
      case lagna:
        return _createPageRoute(LagnaPalapala());
      case rahu_kalaya:
        return _createPageRoute(RaahuKaalaya());
      case dashboard:
        return _createPageRoute(DashBoard());
      default:
        return _createPageRoute(ErrorScreen()); // Fallback route
    }
  }

  static PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define custom transitions here
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration:
          Duration(milliseconds: 300), // Duration of the transition
    );
  }
}
