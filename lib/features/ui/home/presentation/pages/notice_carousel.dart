import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:aurudu_nakath/features/ui/home/data/modals/modal.dart';

class NoticeCarousel extends StatefulWidget {
  final Stream<List<Notice>> noticesStream;

  const NoticeCarousel({Key? key, required this.noticesStream})
      : super(key: key);

  @override
  _NoticeCarouselState createState() => _NoticeCarouselState();
}

class _NoticeCarouselState extends State<NoticeCarousel> {
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

String _getCountdownText(DateTime noticeTime) {
  final Duration difference = noticeTime.difference(DateTime.now());
  if (difference.isNegative) {
    return 'අවසන්';
  }

  final int days = difference.inDays;
  final int hours = difference.inHours % 24;
  final int minutes = difference.inMinutes % 60;
  final int seconds = difference.inSeconds % 60;

  final int months = (days / 30).floor();
  final int years = (months / 12).floor();

  // Create a list to store text components
  List<String> parts = [];

  // Always show each part with two digits, even if zero
 
  parts.add("මා ${months.toString().padLeft(2, '0')}");
  parts.add("දි ${(days % 30).toString().padLeft(2, '0')}");
  parts.add("පැ ${hours.toString().padLeft(2, '0')}");
  parts.add("මි ${minutes.toString().padLeft(2, '0')}");
  parts.add("ත ${seconds.toString().padLeft(2, '0')}");

  return parts.join(' ').trim();
}



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Notice>>(
      stream: widget.noticesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoNoticesWidget();
        } else {
          final notices = snapshot.data!;
          return _buildCarousel(notices);
        }
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 120,
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'Error: $error',
          style: TextStyle(color: Colors.red[800]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNoNoticesWidget() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'No notices available',
          style: TextStyle(color: Colors.blue[800], fontSize: 16),
        ),
      ),
    );
  }

Widget _buildCarousel(List<Notice> notices) {
  return Column(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          
          height: 120,
          autoPlay: false, // Disable auto sliding
          enlargeCenterPage: false,
          viewportFraction: 1.0, // Display one item at a time
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: notices.map((notice) => _buildCarouselItem(notice)).toList(),
      ),
      SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: notices.asMap().entries.map((entry) {
          return Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == entry.key
                  ? Theme.of(context).primaryColor
                  : Colors.grey.withOpacity(0.5),
            ),
          );
        }).toList(),
      ),
    ],
  );
}


 Widget _buildCarouselItem(Notice notice) {
  return Container(
    height: 160, // Increased height to accommodate longer text if needed
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).primaryColor.withOpacity(0.8),
          Theme.of(context).primaryColor.withOpacity(0.6),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (notice.title != null && notice.title!.isNotEmpty) ...[
            Text(
              notice.title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
          ],
          if (notice.subtitle != null && notice.subtitle!.isNotEmpty) ...[
            Expanded( // Allow subtitle to expand
              child: Center(
                child: Text(
                  notice.subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  // Removed maxLines and overflow properties to show full subtitle
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
          if (notice.noticeTime != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 110, 110, 110).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getCountdownText(notice.noticeTime!),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ] else ...[
            // If notice.noticeTime is null or not available, ensure it's hidden
            SizedBox.shrink(),
          ],
        ],
      ),
    ),
  );
}

}
