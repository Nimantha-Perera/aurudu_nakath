import 'package:aurudu_nakath/features/ui/litha/domain/entities/sunan_agawatima.dart';
import 'package:flutter/material.dart';

class SunanAgawatimaWidget extends StatelessWidget {
  final List<SunanAgawatima> sunanAgawatima;

  const SunanAgawatimaWidget({Key? key, required this.sunanAgawatima}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Define light and dark mode colors
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey.shade300;
    final headerTextColor = isDarkMode ? Colors.white : Colors.black;
    final tableHeaderColor = isDarkMode ? Colors.grey[850] : Colors.grey.shade100;
    final tableRowTextColor = isDarkMode ? Colors.white70 : Colors.black87;

    if (sunanAgawatima.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: headerTextColor, // Dynamically adapt text color
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: cardColor, // Apply card color based on the theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'සූනන් අගවැටීම',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: headerTextColor, // Apply text color based on the theme
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(
                color: borderColor!, // Apply border color based on the theme
                width: 1,
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: tableHeaderColor, // Apply header background color
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
                          'ස්ථානය',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: headerTextColor, // Apply text color for headers
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'පලාඵලය',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: headerTextColor, // Apply text color for headers
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                ...sunanAgawatima.map((data) => TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.thana,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tableRowTextColor, // Apply text color for rows
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.palapala,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tableRowTextColor, // Apply text color for rows
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
