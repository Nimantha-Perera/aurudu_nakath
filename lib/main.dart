import 'package:aurudu_nakath/loadin_screen/firebase_api.dart';
import 'package:aurudu_nakath/loadin_screen/loading.dart';
import 'package:aurudu_nakath/screens/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/screens/home.dart';
import 'package:aurudu_nakath/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('si_LK');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Or any other desired orientation
  ]);

  
    await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDPZPB6v5SqppWZbqYZ3JV0oWd3AUxkTYs",
        authDomain: "nakath-af5a0.firebaseapp.com",
        databaseURL: "https://nakath-af5a0-default-rtdb.firebaseio.com",
        projectId: "nakath-af5a0",
        storageBucket: "nakath-af5a0.appspot.com",
        messagingSenderId: "91523853816",
        appId: "1:91523853816:web:2e7db1e0dcff9cfc69fa0d",
        measurementId: "G-VTC0XKG0QW"),
  ); // Add Firebase initialization if required
  // FirebaseApi.configureFirebaseMessaging();
  // AwesomeNotifications().initialize(
  //   'resource://mipmap/ic_launcher', // Replace with the name of your icon resource
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic notifications',
  //       defaultColor: Color(0xFF9D50DD),
  //       ledColor: Colors.white,
  //     ),
  //   ],
  // );

  runApp(MyApp());
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
    checkForUpdate();
  }


  // Check Updates
Future<void> checkForUpdate() async {
  print('checking for Update');
  try {
    var info = await InAppUpdate.checkForUpdate();
    setState(() {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('update available');
        update();
      }
    });
  } catch (e) {
    print('Failed to bind to the service: $e');
    // Handle the failure, show a message to the user, or retry
  }
}


  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<Widget>(
      future: _appWidget,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Sinhala',
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
      print("First time user");
      await prefs.setBool('isFirstTime', false);
      return Onboarding();
    } else {
      print("Returning HomeScreen");

      return HomeScreen();
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
                'assets/no_connection.json', // Replace with the correct path to your Lottie file
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
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
