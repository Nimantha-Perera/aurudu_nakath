// lib/presentation/routes.dart

import 'package:aurudu_nakath/features/ui/Compass/compass.dart';
import 'package:aurudu_nakath/features/ui/aurudu_nakath/presentation/pages/main_screen.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/chat_view.dart';
import 'package:aurudu_nakath/features/ui/rahu_kalaya/presentation/pages/raahu_kaalaya_page.dart';
import 'package:aurudu_nakath/main.dart';
import 'package:aurudu_nakath/screens/hela_ai.dart';

import 'package:flutter/material.dart';
import 'package:aurudu_nakath/screens/home.dart';
import 'package:aurudu_nakath/screens/lagna.dart';
import 'package:aurudu_nakath/screens/nakath_sittuwa.dart';
import 'package:aurudu_nakath/features/ui/help/presentation/pages/help_screen.dart';
import 'package:aurudu_nakath/features/ui/intro_screens/onboarding_screen/onboarding_screen.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';

class AppRoutes {
  static const String home = '/';
  static const String help = '/help';
  static const String onboarding = '/onboarding';
  static const String aurudu_nakath= '/aurudu_nakath';
  static const String lagna = '/lagna';
  static const String dashboard = '/dashboard';

  static const String rahu_kalaya= '/rahu_kalaya';
  static const String hela_gpt = '/hela_gpt';
  static const String malimawa = '/malimawa';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case help:
        return MaterialPageRoute(builder: (_) => HelpScreen());

      case malimawa:
        return MaterialPageRoute(builder: (_) => Compass());  

      case hela_gpt:
        return MaterialPageRoute(builder: (_) => ChatView());
      
      case onboarding:
        return MaterialPageRoute(builder: (_) => Onboarding());
      case aurudu_nakath:
        return MaterialPageRoute(builder: (_) => AuruduNakath());
      case lagna:
        return MaterialPageRoute(builder: (_) => LagnaPalapala());

      case rahu_kalaya:
        return MaterialPageRoute(builder: (_) => RaahuKaalaya());  
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashBoard());
      default:
        return MaterialPageRoute(builder: (_) => ErrorScreen()); // Fallback route
    }
  }
}
