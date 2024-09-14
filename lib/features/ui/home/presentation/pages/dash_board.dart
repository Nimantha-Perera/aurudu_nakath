import 'package:aurudu_nakath/features/ui/home/data/modals/modal.dart';
import 'package:aurudu_nakath/features/ui/home/data/repostory/notice_repository.dart';
import 'package:aurudu_nakath/features/ui/permissions/permissions_hadler.dart';
import 'package:aurudu_nakath/features/ui/tutorial/tutorial_coach_mark.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/jyothishya_sewa.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/tools_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'; // Import Tutorial Coach Mark
import 'notice_carousel.dart'; // Import the new widget
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final PermissionHandler permissionHandler = PermissionHandler();
  bool _isNotificationGranted = false;
  late final NoticeRepository _noticeRepository; // Add NoticeRepository
  late Stream<List<Notice>> _noticesStream; // Stream for notices

  // GlobalKeys for tutorial targets
  final GlobalKey _notificationIconKey = GlobalKey();
  final GlobalKey _noticeCarouselKey = GlobalKey();
  final GlobalKey _jyothishyaKey = GlobalKey();
  final GlobalKey _toolsKey = GlobalKey();

  List<TargetFocus> targets = [];
  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    _noticeRepository = NoticeRepositoryImpl(firestore: FirebaseFirestore.instance);
    _noticesStream = _noticeRepository.getNotices(); // Initialize stream
    _loadTutorialState();
  }

  Future<void> _loadTutorialState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tutorialShown = prefs.getBool('tutorial_dash_shown') ?? false;
    });

    // Show tutorial if not already shown
    if (!_tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setupAndShowTutorial(); // Setup tutorial after the widget is built
      });
    }
  }

  Future<void> _setTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_dash_shown', true);
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _isNotificationGranted = status.isGranted;
    });
  }

  Future<void> _requestPermissionAndChangeIcon() async {
    if (_isNotificationGranted) {
      _showPermissionGrantedDialog();
    } else {
      await permissionHandler.requestPermissions();
      _checkNotificationPermission();
    }
  }

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

  void _setupAndShowTutorial() {
  // Define the targets for the tutorial
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
        text: "ඔබට ලබා ගත හැකි විවිධ මෙවලම් පරීක්ෂා කරන්න.",
        align: ContentAlign.top,
        shape: ShapeLightFocus.RRect,
      ),
    ];

    // Show the tutorial
    TutorialHelper.showTutorial(
      context: context,
      targets: targets,
    );

    // Set the tutorial as shown after completion
    _setTutorialShown();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "කෙටි දැන්වීම්", // Special notifications
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          key: _notificationIconKey, // Attach tutorial key
                          onPressed: () async {
                            await _requestPermissionAndChangeIcon();
                          },
                          icon: Icon(
                            _isNotificationGranted
                                ? Icons.notifications_active
                                : Icons.notifications_off,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Use the NoticeCarousel widget with a key for the tutorial
                    NoticeCarousel(
                      key: _noticeCarouselKey,
                      noticesStream: _noticesStream,
                    ),

                    SizedBox(height: 50),

                    // Jyothishya Sewa (Astrological Service) with a tutorial key
                    Jyothishya(key: _jyothishyaKey),

                    // Tools section with a tutorial key
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
