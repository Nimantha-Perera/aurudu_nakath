import 'package:aurudu_nakath/features/ui/help/data/modals/help_topic.dart';
import 'package:aurudu_nakath/features/ui/help/data/repositories/help_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/help/presentation/bloc/help_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  final HelpPresenter presenter = HelpPresenter(HelpRepositoryImpl());

  @override
  Widget build(BuildContext context) {
    List<HelpTopic> topics = presenter.getHelpTopics();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
        title: Text('උදව්', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              // Toggle theme (you need to implement this functionality)
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.grey[100]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSerifSinhala(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.pinkAccent[100] : Color(0xFF6D003B),
              ),
            ),
            const SizedBox(height: 12.0),
            MarkdownBody(
              data: description,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.notoSerifSinhala(
                  fontSize: 16.0,
                  color: isDarkMode ? Colors.grey[300] : Colors.black87,
                  height: 1.6,
                ),
                listBullet: TextStyle(
                  fontSize: 16.0,
                  color: isDarkMode ? Colors.grey[300] : Colors.black87,
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

// Add this to your main.dart or wherever you set up your MaterialApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurudu Nakath App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF6D003B),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6D003B),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        textTheme: TextTheme(
          titleMedium: GoogleFonts.notoSerifSinhala(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.pinkAccent[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.grey[800],
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        textTheme: TextTheme(
          titleMedium: GoogleFonts.notoSerifSinhala(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system, // This will respect the system theme
      home: HelpScreen(),
    );
  }
}