import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';
import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OtherTools extends StatefulWidget {
  const OtherTools({Key? key}) : super(key: key);

  @override
  State<OtherTools> createState() => _OtherToolsState();
}

class _OtherToolsState extends State<OtherTools> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardAnimations = List.generate(
      4,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1 * index, 0.1 * index + 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final bool isDarkTheme = themeNotifier.getTheme() == darkTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      
        title: Text('ජ්‍යෝතීශ්‍ය මෙනුව', style: GoogleFonts.notoSerifSinhala(fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              isDarkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.3),
              BlendMode.dstATop,
            ),
            child: Image.asset(
              'assets/app_background/backimg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAnimatedCard(
                      animation: _cardAnimations[0],
                      text: "අවුරුදු නැකැත්",
                      icon: Icons.timelapse_rounded,
                      routeName: AppRoutes.aurudu_nakath,
                    ),
                    _buildAnimatedCard(
                      animation: _cardAnimations[1],
                      text: "‍රාහු කාලය",
                      icon: Icons.watch_later_rounded,
                      routeName: AppRoutes.rahu_kalaya,
                    ),
                    _buildAnimatedCard(
                      animation: _cardAnimations[2],
                      text: "ලිත",
                      image: AssetImage('assets/icons/astronomy.png'),
                      routeName: AppRoutes.litha,
                    ),
                    _buildAnimatedCard(
                      animation: _cardAnimations[3],
                      text: "ලග්න පලාඵල",
                      image: AssetImage('assets/icons/constellation.png'),
                      routeName: AppRoutes.lagna,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({
    required Animation<double> animation,
    required String text,
    IconData? icon,
    ImageProvider<Object>? image,
    required String routeName,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: _buildCustomCard(
              text: text,
              icon: icon,
              image: image,
              routeName: routeName,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomCard({
    required String text,
    IconData? icon,
    ImageProvider<Object>? image,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 8,
        color: const Color(0xFFFABC3F),
        shadowColor: Colors.orangeAccent.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: image != null
                    ? Image(image: image, height: 40, width: 40)
                    : Icon(icon, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifSinhala(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}