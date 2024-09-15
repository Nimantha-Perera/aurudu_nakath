import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherTools extends StatefulWidget {
  const OtherTools({super.key});

  @override
  State<OtherTools> createState() => _OtherToolsState();
}

class _OtherToolsState extends State<OtherTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          'ජ්‍යෝතීශ්‍ය මෙනුව',  
          style: GoogleFonts.notoSerifSinhala(fontSize: 14.0, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400, // Define a fixed height for the GridView
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24, // Increased spacing for cleaner layout
                    crossAxisSpacing: 16,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildCustomCard(
                        text: "අවුරුදු නැකැත්",
                        color: const Color(0xFFFABC3F),
                        icon: Icons.timelapse_rounded,
                        routeName: AppRoutes.aurudu_nakath,
                      ),
                      _buildCustomCard(
                        text: "‍රාහු කාලය",
                        color: const Color(0xFFFABC3F),
                        icon: Icons.watch_later_rounded,
                        routeName: AppRoutes.rahu_kalaya,
                      ),
                      _buildCustomCard(
                        text: "ලිත",
                        color: const Color(0xFFFABC3F),
                        image: AssetImage('assets/icons/astronomy.png'),
                        routeName: AppRoutes.litha,
                      ),
                      _buildCustomCard(
                        text: "ලග්න පලාඵල",
                        color: const Color(0xFFFABC3F),
                        image: AssetImage('assets/icons/constellation.png'),
                        routeName: AppRoutes.lagna,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   Widget _buildCustomCard({
    required String text,
    required Color color,
    IconData? icon, // Make the icon nullable
    ImageProvider<Object>? image, // Add an optional image parameter
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0), // Add ripple effect with rounded corners
        splashColor: Colors.orange.withOpacity(0.3), // Define the ripple color
        highlightColor: Colors.transparent, // Remove default highlight
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8,
          color: color,
          shadowColor: Colors.orangeAccent.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Conditionally display either the icon or the image
                image != null
                    ? Image(
                        image: image,
                        height: 40,
                        width: 40,
                      )
                    : Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
