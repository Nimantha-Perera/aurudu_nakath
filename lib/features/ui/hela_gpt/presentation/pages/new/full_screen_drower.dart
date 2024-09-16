import 'package:flutter/material.dart';

class FullScreenDrawer extends StatelessWidget {
  final VoidCallback onClose;

  FullScreenDrawer({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pro Features',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.teal),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      children: [
                        ListTile(
                          leading: Icon(Icons.star, color: Colors.teal),
                          title: Text(
                            'සම්බන්ධතා විකල්පය',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'වෙත සම්බන්ධතා සඳහා වඩාත් සුදුසු අංග.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        ListTile(
                          leading: Icon(Icons.star, color: Colors.teal),
                          title: Text(
                            'සාධාරණ පිළිගැනීම',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'ඉහළ ප්‍රතිචාර සහ පිළිගැනීම.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        ListTile(
                          leading: Icon(Icons.star, color: Colors.teal),
                          title: Text(
                            'පෞද්ගලික සබැඳි',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'ඔබගේ පෞද්ගලික සබැඳි සඳහා වඩාත් සුදුසුකම්.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        SizedBox(height: 20),
                        // Add buttons with white background, black text, and rounded corners
                        ElevatedButton(
                          onPressed: () {
                            // Add your button action here
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Text('Explore Features'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Add your button action here
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Text('Contact Support'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
