import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NoticeCarousel extends StatelessWidget {
  final Stream<List<String>> noticesStream;

  const NoticeCarousel({Key? key, required this.noticesStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: noticesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Shimmer effect while loading
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No notices available'));
        } else {
          final notices = snapshot.data!;
          return notices.length > 1
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: 120,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 5),
                    aspectRatio: 2.0,
                    viewportFraction: 1.0,
                  ),
                  items: notices.map((notice) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Center(
                            child: Text(
                              notice,
                              style: TextStyle(fontSize: 12, color: Theme.of(context).focusColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 184, 184, 184),
                  ),
                  height: 120,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    notices[0],
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
        }
      },
    );
  }
}
