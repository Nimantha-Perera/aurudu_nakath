import 'package:aurudu_nakath/features/ui/home/data/repostory/notice_repository.dart';
import 'package:aurudu_nakath/features/ui/permissions/permissions_hadler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/jyothishya_sewa.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/tools_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'notice_carousel.dart'; // Import the new widget

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final PermissionHandler permissionHandler = PermissionHandler();
  bool _isNotificationGranted = false;
  late final NoticeRepository _noticeRepository; // Add NoticeRepository
  late Stream<List<String>> _noticesStream; // Stream for notices

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    _noticeRepository = NoticeRepositoryImpl(firestore: FirebaseFirestore.instance);
    _noticesStream = _noticeRepository.getNotices(); // Initialize stream
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _isNotificationGranted = status.isGranted;
    });
  }

  Future<void> _requestPermissionAndChangeIcon() async {
    await permissionHandler.requestPermissions();
    _checkNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          "විශේෂ දැනුම්දීම්", // Special notifications
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
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

                    // Use the NoticeCarousel widget
                    NoticeCarousel(noticesStream: _noticesStream),

                    SizedBox(height: 50),

                    // Jyothishya Sewa (Astrological Service)
                    Jyothishya(),

                    // Tools
                    Tools(),
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
