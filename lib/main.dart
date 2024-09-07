// import 'package:aurudu_nakath/Push_Notifications/push_notificatrions.dart';
import 'package:aurudu_nakath/Compass/compass.dart';
import 'package:aurudu_nakath/Tools/tools_menu.dart';
import 'package:aurudu_nakath/features/ui/help/presentation/pages/help_screen.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/firebase_options.dart';
import 'package:aurudu_nakath/loadin_screen/firebase_api.dart';
import 'package:aurudu_nakath/loadin_screen/loading.dart';
import 'package:aurudu_nakath/screens/aurudu_nakath.dart';
import 'package:aurudu_nakath/screens/hela_ai.dart';
import 'package:aurudu_nakath/screens/lagna.dart';
import 'package:aurudu_nakath/screens/nakath_sittuwa.dart';
import 'package:aurudu_nakath/screens/raahu_kalaya.dart';
import 'package:aurudu_nakath/screens/splash_screen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/screens/home.dart';
import 'package:aurudu_nakath/features/ui/intro_screens/onboarding_screen/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('si_LK');
  await dotenv.load(fileName: "assets/.env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true, // Enable device preview (set to `false` for release builds)
      builder: (context) => MyApp(), // Wrap your app with DevicePreview
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
                  Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
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