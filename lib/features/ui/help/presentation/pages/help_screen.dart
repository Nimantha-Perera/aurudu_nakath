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
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        centerTitle: true,
        title: Text(
          'උදව්',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey<bool>(isDarkMode),
                ),
              ),
              onPressed: () {
                // Theme toggle implementation
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    Color(0xFF1A1A1A),
                    Color(0xFF2D2D2D),
                  ]
                : [
                    Color(0xFFF8F9FA),
                    Colors.white,
                  ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: 1.0,
              child: AnimatedPadding(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(top: index == 0 ? 0 : 16),
                child: HelpTopicCard(
                  title: topics[index].title,
                  description: topics[index].description,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HelpTopicCard extends StatefulWidget {
  final String title;
  final String description;

  const HelpTopicCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<HelpTopicCard> createState() => _HelpTopicCardState();
}

class _HelpTopicCardState extends State<HelpTopicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isDarkMode
                ? Color(0xFF2A2A2A)
                : Theme.of(context).cardColor,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Color(0xFFFFD700)
                          : Color(0xFFB8860B),
                    ),
                  ),
                  SizedBox(height: 12),
                  MarkdownBody(
                    data: widget.description,
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.notoSerifSinhala(
                        fontSize: 16,
                        color: isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[800],
                        height: 1.6,
                      ),
                      listBullet: TextStyle(
                        color: isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF8F9FA),
    primaryColor: Color(0xFF6D003B),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF6D003B),
      secondary: Color(0xFFB8860B),
      onBackground: Color(0xFF2D2D2D),
    ),
    cardColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.1),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF1A1A1A),
    primaryColor: Color(0xFFFF9AAD),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFFF9AAD),
      secondary: Color(0xFFFFD700),
      onBackground: Colors.white,
    ),
    cardColor: Color(0xFF2A2A2A),
    shadowColor: Colors.black.withOpacity(0.3),
  );
}