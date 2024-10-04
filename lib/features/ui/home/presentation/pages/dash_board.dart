import 'package:aurudu_nakath/FirebaeInappMessaging/firebase_in_app_message.dart';
import 'package:aurudu_nakath/features/ui/Review/review_provider.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/jyothishya_sewa.dart';
import 'package:aurudu_nakath/features/ui/maintance/maintance_screen.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/tools_view.dart';
import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';
import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/data/modals/modal.dart';
import 'package:aurudu_nakath/features/ui/home/data/repostory/notice_repository.dart';
import 'package:aurudu_nakath/features/ui/permissions/permissions_hadler.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:aurudu_nakath/features/ui/tutorial/tutorial_coach_mark.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notice_carousel.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final PermissionHandler permissionHandler = PermissionHandler();
  bool _isNotificationGranted = false;
  late final NoticeRepository _noticeRepository;
  late Stream<List<Notice>> _noticesStream;
  late SubscriptionProvider _subscriptionProvider;

  // GlobalKeys for tutorial targets
  final GlobalKey _notificationIconKey = GlobalKey();
  final GlobalKey _noticeCarouselKey = GlobalKey();
  final GlobalKey _jyothishyaKey = GlobalKey();
  final GlobalKey _toolsKey = GlobalKey();

  List<TargetFocus> targets = [];
  bool _tutorialShown = false;
  String? _token;
  final FirebaseInAppMessage _firebaseInAppMessage = FirebaseInAppMessage();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  @override
 Future<void> _getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      setState(() {
        _token = token; // Store the token
      });
      print("FCM Token: $_token"); // Log the token
    } catch (e) {
      print("Error getting FCM token: $e");
    }

 }
  void initState() {
    _firebaseInAppMessage.showInAppMessage();
    _getToken();
    Provider.of<ReviewProvider>(context, listen: false).requestReview();
    super.initState();
    // Initialize Firestore instance
    final firestore = FirebaseFirestore.instance;

    _checkNotificationPermission();

    // Initialize other repositories and providers
    _noticeRepository = NoticeRepositoryImpl(firestore: firestore);
    _noticesStream = _noticeRepository.getNotices();
    _subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);

    _loadTutorialState();
  }

  // Check if the app is in maintenance mode

  // Load tutorial state from SharedPreferences
  Future<void> _loadTutorialState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tutorialShown = prefs.getBool('tutorial_dash_shown') ?? false;
    });

    if (!_tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setupAndShowTutorial();
      });
    }
  }

  // Set tutorial as shown in SharedPreferences
  Future<void> _setTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_dash_shown', true);
  }

  // Check notification permission
  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _isNotificationGranted = status.isGranted;
    });
  }

  // Request notification permission and update icon
  Future<void> _requestPermissionAndChangeIcon() async {
    if (_isNotificationGranted) {
      _showPermissionGrantedDialog();
    } else {
      await permissionHandler.requestPermissions();
      _checkNotificationPermission();
    }
  }

  // Show a dialog when permission is already granted
  void _showPermissionGrantedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("අවසර ලබා දී ඇත"),
          content: Text("දැනුම්දීම් දැනටමත් සබල කර ඇත."),
          actions: [
            TextButton(
              child: Text("හරි"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Set up and show tutorial
  void _setupAndShowTutorial() {
    setState(() {
      targets = [
        TutorialHelper.createCustomTarget(
          identify: "NotificationIcon",
          keyTarget: _notificationIconKey,
          text: "දිනපතා දැනුම්දීම් ලබා ගැනීමට මෙය Touch කරන්න",
          align: ContentAlign.bottom,
          shape: ShapeLightFocus.Circle,
        ),
        TutorialHelper.createCustomTarget(
          identify: "NoticeCarousel",
          keyTarget: _noticeCarouselKey,
          text: "මෙහි නැකැත් කෙටි විස්තර පෙන්වනු ලබයි.",
          align: ContentAlign.bottom,
          shape: ShapeLightFocus.RRect,
        ),
        TutorialHelper.createCustomTarget(
          identify: "Jyothishya",
          keyTarget: _jyothishyaKey,
          text: "ජ්‍යෝතීශ්‍ය සේවාවන් මෙතනින් ලබා ගන්න.",
          align: ContentAlign.bottom,
          shape: ShapeLightFocus.RRect,
        ),
        TutorialHelper.createCustomTarget(
          identify: "Tools",
          keyTarget: _toolsKey,
          text: "ඔබට ලබා ගත හැකි විවිධ මෙවලම් Scroll කර පරීක්ෂා කරන්න.",
          align: ContentAlign.top,
          shape: ShapeLightFocus.RRect,
        ),
      ];

      TutorialHelper.showTutorial(
        context: context,
        targets: targets,
      );

      _setTutorialShown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: themeNotifier.getTheme() == darkTheme ? 0.5 : 0.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    themeNotifier.getTheme() == darkTheme
                        ? 'assets/app_background/backimg.png' // Dark mode image
                        : 'assets/app_background/backimg.png', // Light mode image
                  ),
                  fit: BoxFit.cover, // Adjust how the image fits the background
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 50, bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "කෙටි දැන්වීම්",
                          // Adjust text color for better contrast
                        ),
                        IconButton(
                          key: _notificationIconKey,
                          onPressed: () async {
                            await _requestPermissionAndChangeIcon();
                          },
                          icon: Icon(
                            _isNotificationGranted
                                ? Icons.notifications_active
                                : Icons.notifications_off,
                            // Adjust icon color for better contrast
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    NoticeCarousel(
                      key: _noticeCarouselKey,
                      noticesStream: _noticesStream,
                    ),
                    SizedBox(height: 10),
                    Jyothishya(key: _jyothishyaKey),
                    Tools(key: _toolsKey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
