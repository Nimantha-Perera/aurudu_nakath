import 'package:flutter/material.dart';

class KonaMasaWidget extends StatelessWidget {
  final List<String> konaMasa;

  const KonaMasaWidget({Key? key, required this.konaMasa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final headerColor = isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100;
    final borderColor = isDarkMode ? const Color(0xFF404040) : Colors.grey.shade300;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.grey[300] : Colors.black87;

    if (konaMasa.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      );
    }

    return Card(
      elevation: isDarkMode ? 8 : 4,
      margin: const EdgeInsets.all(16),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: isDarkMode
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Table(
                border: TableBorder.all(
                  color: borderColor,
                  width: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: headerColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'කෝණ මාස',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...konaMasa.map((data) => TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color(0xFF262626)
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  data,
                                  style: TextStyle(color: secondaryTextColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}