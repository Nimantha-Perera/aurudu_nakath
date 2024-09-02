import 'package:aurudu_nakath/features/help/data/modals/help_topic.dart';
import 'package:aurudu_nakath/features/help/data/repositories/help_repository_impl.dart';
import 'package:aurudu_nakath/features/help/presentation/bloc/help_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  final HelpPresenter presenter = HelpPresenter(HelpRepositoryImpl());

  @override
  Widget build(BuildContext context) {
    List<HelpTopic> topics = presenter.getHelpTopics();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D003B),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Help'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: topics.map((topic) {
                  return HelpTopicCard(
                    title: topic.title,
                    description: topic.description,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpTopicCard extends StatelessWidget {
  final String title;
  final String description;

  const HelpTopicCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSerifSinhala(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D003B),
              ),
            ),
            const SizedBox(height: 8.0),
            MarkdownBody(
              data: description,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.notoSerifSinhala(
                  fontSize: 14.0,
                  color: Colors.black87,
                  height: 1.4,
                ),
                listBullet: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
