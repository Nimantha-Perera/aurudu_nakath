import 'dart:convert';
import 'package:aurudu_nakath/Notifications/notification_service.dart';
import 'package:aurudu_nakath/features/ui/Login/data/repostorys/auth_repository.dart';
import 'package:aurudu_nakath/features/ui/Login/domain/repo/auth_repository_interface.dart';
import 'package:aurudu_nakath/features/ui/Login/domain/usecase/sign_in_with_google.dart';
import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_screen.dart';
import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/Login2/data/repostorys/auth_repository.dart';
import 'package:aurudu_nakath/features/ui/Login2/domain/repo/auth_repository_interface.dart';
import 'package:aurudu_nakath/features/ui/Login2/domain/usecase/sign_in_with_google.dart';
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/Review/review_provider.dart';
import 'package:aurudu_nakath/features/ui/compass/compass.dart';
import 'package:aurudu_nakath/Tools/tools_menu.dart';
import 'package:aurudu_nakath/features/ui/errors/error_screen.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_text_message.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/prvider/post_provider.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/datasource.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_text_message.dart';
import 'package:aurudu_nakath/features/ui/help/presentation/pages/help_screen.dart';

import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';
import 'package:aurudu_nakath/features/ui/in_app_update/in_app_update.dart';
import 'package:aurudu_nakath/features/ui/litha/data/datasouces/firebase_data_source.dart';
import 'package:aurudu_nakath/features/ui/litha/data/repo/aurudu_nakath_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/usecase/get_aurudu_nakath_data.dart';
import 'package:aurudu_nakath/features/ui/litha/presentation/bloc/aurudu_nakath_bloc.dart';
import 'package:aurudu_nakath/features/ui/maintance/usecase.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository.dart';
import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/settings/presentation/bloc/settings_bloc.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';
import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:aurudu_nakath/features/ui/theme/light_theme.dart';
import 'package:aurudu_nakath/firebase_options.dart';
import 'package:aurudu_nakath/loadin_screen/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:aurudu_nakath/features/ui/intro_screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'features/ui/hela_post/domain/usecase/getallpost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('si_LK');

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    runApp(MaterialApp(home: ErrorScreen())); // Error handling
    return;
  }

  NotificationService notificationService =
      NotificationService(); // Create instance of NotificationService
  await notificationService.initialize(); // Initialize notifications

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();
  await dotenv.load(fileName: "assets/.env");

  final sharedPreferences = await SharedPreferences.getInstance();
  final apiKey = dotenv.env['API_KEY'] ?? "";
  final apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

  runApp(
    MultiProvider(
      providers: [


        Provider<AuthRepositoryInterface2>(create: (_) => AuthRepository2()),
        Provider<SignInWithGoogle2>(
            create: (context) =>
                SignInWithGoogle2(context.read<AuthRepositoryInterface2>())),
        ChangeNotifierProvider(
            create: (context) =>
                LoginViewModel2(context.read<SignInWithGoogle2>())),
        // ChangeNotifierProvider(
        //   create: (context) => PostProvider(
        //     GetAllPosts(PostRepositoryImpl(FirebasePostDataSource(FirebaseFirestore.instance)))..fetchAllPosts(),
        //   ),
        // ),
        ChangeNotifierProvider(
            create: (_) => PostProvider(GetAllPosts(PostRepositoryImpl(
                FirebasePostDataSource(FirebaseFirestore.instance))))),
        Provider<AuthRepositoryInterface>(create: (_) => AuthRepository()),
        Provider<SignInWithGoogle>(
            create: (context) =>
                SignInWithGoogle(context.read<AuthRepositoryInterface>())),
        ChangeNotifierProvider(
            create: (context) =>
                LoginViewModel(context.read<SignInWithGoogle>())),
        ChangeNotifierProvider<ReviewProvider>(
          create: (_) => ReviewProvider(),
        ),
        ChangeNotifierProvider<SubscriptionProvider>(
          create: (_) => SubscriptionProvider(),
        ),
        Provider<FirebaseDataSource>(
          create: (_) => FirebaseDataSource(),
        ),
        ProxyProvider<FirebaseDataSource, AuruduNakathRepositoryImpl>(
          update: (_, dataSource, __) =>
              AuruduNakathRepositoryImpl(dataSource: dataSource),
        ),
        ProxyProvider<AuruduNakathRepositoryImpl, GetAuruduNakathData>(
          update: (_, repository, __) =>
              GetAuruduNakathData(repository: repository),
        ),
        ProxyProvider<GetAuruduNakathData, AuruduNakathBloc>(
          update: (_, getAuruduNakathData, __) =>
              AuruduNakathBloc(getAuruduNakathData: getAuruduNakathData),
          dispose: (_, bloc) => bloc.close(),
        ),
        Provider<SharedPreferences>.value(value: sharedPreferences),
        ChangeNotifierProvider(create: (_) => themeNotifier),
        Provider<SettingsRepository>(create: (_) => SettingsRepositoryImpl()),
        Provider<SettingsBloc>(
            create: (context) =>
                SettingsBloc(context.read<SettingsRepository>())),
        Provider<FetchManageMessagesUseCase>(
            create: (_) => FetchManageMessagesUseCase(sharedPreferences)),
        Provider<SendTextMessageUseCase>(
            create: (_) => SendTextMessageUseCase(apiKey, apiUrl)),
        Provider<SendImageMessageUseCase>(
            create: (_) => SendImageMessageUseCase(apiKey)),
        Provider<ClearChatHistoryUseCase>(
            create: (_) => ClearChatHistoryUseCase(sharedPreferences)),
        Provider<FetchManageMessagesUseCase2>(
            create: (_) => FetchManageMessagesUseCase2(sharedPreferences)),
        Provider<SendTextMessageUseCase2>(
            create: (_) => SendTextMessageUseCase2(apiKey, apiUrl)),
        Provider<SendImageMessageUseCase2>(
            create: (_) => SendImageMessageUseCase2(apiKey)),
        Provider<ClearChatHistoryUseCase2>(
            create: (_) => ClearChatHistoryUseCase2(sharedPreferences)),
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
  late Future<SharedPreferences> _sharedPreferencesFuture;
  //  ShakeNavigation? _shakeNavigation;
  late UseCaseMaintainsFirebase maintenanceUseCase;
  @override
  void initState() {
    super.initState();

    // Check maintenance mode when the widget is first built

    //  _shakeNavigation = ShakeNavigation(context);
    Provider.of<SubscriptionProvider>(context, listen: false)
        .loadSubscriptionStatus();
    //in app update check
    update(context);

    _sharedPreferencesFuture = SharedPreferences.getInstance();
    _appWidget = _checkConnectivityAndFirstTime();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _appWidget = _checkConnectivityAndFirstTime();
      });
    });
  }

  Future<Widget> _checkConnectivityAndFirstTime() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return ErrorScreen(); // Show error screen if no connectivity
    }

    final sharedPreferences = await _sharedPreferencesFuture;
    final isFirstTime = sharedPreferences.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      // Set 'isFirstTime' to false after showing the onboarding screen

      return Onboarding(); // Return onboarding screen if first time
    }
    return DashBoard(); // Return the main dashboard otherwise
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics =
        FirebaseAnalytics.instance; // Use named constructor
    FirebaseAnalyticsObserver observer =
        FirebaseAnalyticsObserver(analytics: analytics);
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return FutureBuilder<Widget>(
          future: _appWidget,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeNotifier.getThemeMode(), // Optimized theme mode
                initialRoute: AppRoutes.home,
                navigatorObservers: [observer],
                onGenerateRoute: AppRoutes.generateRoute,
                home: snapshot.data ??
                    DashBoard(), // Default to Dashboard if no data
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: LoadingScreen(),
              );
            }
          },
        );
      },
    );
  }
}
