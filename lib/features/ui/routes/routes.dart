import 'package:aurudu_nakath/features/ui/helagpt_pro/helagpt_pro.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/helagptpro.dart';
import 'package:aurudu_nakath/features/ui/lagna_palapala/presentation/pages/lagna_palapala_screen.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/pages/litha_main.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/compass/compass.dart';
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
import 'package:provider/provider.dart';


class AppRoutes {
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        final subscriptionProvider =
            Provider.of<SubscriptionProvider>(context, listen: false);

        switch (settings.name) {
          case help:
            return HelpScreen();

          case litha:
            return LithaMainScreen();
          case other_tools:
            return OtherTools();

          case helagptPro:
            // Check if the user is subscribed
            if (subscriptionProvider.isSubscribed) {
              return HelaGPT_PRO();  // Allow access to HelaGPT Pro screen
            } else {
              // Show an error screen or redirect to a subscription page
              return ChatView();
            }

          case setting:
            return SettingsPage();
          case malimawa:
            return Compass();
          case onboarding:
            return Onboarding();
          case aurudu_nakath:
            return AuruduNakath();
          case lagna:
            return LagnaPalapala();
          case rahu_kalaya:
            return RaahuKaalaya();
          case dashboard:
            return DashBoard();

          default:
            return ErrorScreen(); // Fallback route
        }
      },
    );
  }
}
