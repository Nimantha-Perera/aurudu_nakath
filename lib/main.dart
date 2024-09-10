import 'dart:convert';

import 'package:aurudu_nakath/features/ui/Compass/compass.dart';
import 'package:aurudu_nakath/Tools/tools_menu.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_text_message.dart';
import 'package:aurudu_nakath/features/ui/help/presentation/pages/help_screen.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository.dart';
import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/settings/presentation/bloc/settings_bloc.dart';
import 'package:aurudu_nakath/features/ui/settings/settings_module.dart';
import 'package:aurudu_nakath/firebase_options.dart';
import 'package:aurudu_nakath/loadin_screen/firebase_api.dart';
import 'package:aurudu_nakath/loadin_screen/loading.dart';
import 'package:aurudu_nakath/screens/aurudu_nakath.dart';
import 'package:aurudu_nakath/screens/hela_ai.dart';
import 'package:aurudu_nakath/screens/lagna.dart';
import 'package:aurudu_nakath/screens/nakath_sittuwa.dart';
import 'package:aurudu_nakath/screens/raahu_kalaya.dart';
import 'package:aurudu_nakath/screens/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/screens/home.dart';
import 'package:aurudu_nakath/features/ui/intro_screens/onboarding_screen/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/.env");

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  final apiKey = dotenv.env['API_KEY'] ?? "";
  final apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

  runApp(
    MultiProvider(
      providers: [
        // Provide SharedPreferences
        Provider<SharedPreferences>.value(value: sharedPreferences),

        // Provide SettingsRepository and Bloc
        Provider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(),
        ),
        Provider<SettingsBloc>(
          create: (context) => SettingsBloc(context.read<SettingsRepository>()),
        ),

        // Provide use cases
        Provider<FetchManageMessagesUseCase>(
          create: (context) => FetchManageMessagesUseCase(sharedPreferences),
        ),
        Provider<SendTextMessageUseCase>(
          create: (_) => SendTextMessageUseCase(apiKey, apiUrl),
        ),
        Provider<SendImageMessageUseCase>(
          create: (_) => SendImageMessageUseCase(apiKey),
        ),
        Provider<ClearChatHistoryUseCase>(
          create: (_) => ClearChatHistoryUseCase(sharedPreferences),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Widget>? _appWidget;

  @override
  void initState() {
    super.initState();
    _appWidget = _checkConnectivityAndFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    print("App Widget: $_appWidget");
    return FutureBuilder<Widget>(
      future: _appWidget,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.home,
            onGenerateRoute: AppRoutes.generateRoute,
            theme: ThemeData(
              fontFamily: GoogleFonts.notoSerifSinhala().fontFamily,
            ),
            home: snapshot.data,
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoadingScreen(),
          );
        }
      },
    );
  }

  Future<Widget> _checkConnectivityAndFirstTime() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return ErrorScreen(); // Return the error screen if no internet connection
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      return Onboarding();
    } else {
      return DashBoard();
    }
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 100),
              child: Lottie.asset(
                'assets/no_connection.json',
                height: 400,
                width: 400,
              ),
            ),
            Text("No internet connection"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult != ConnectivityResult.none) {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.dashboard);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Still no internet connection"),
                    ),
                  );
                }
              },
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
