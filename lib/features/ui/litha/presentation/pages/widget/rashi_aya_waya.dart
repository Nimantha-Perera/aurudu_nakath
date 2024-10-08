import 'package:aurudu_nakath/features/ui/litha/domain/entities/rashi_aya_waya.dart';
import 'package:flutter/material.dart';

class RashiAyaWayaScreen extends StatelessWidget {
  final List<RashiAyawaya> rashi_aya_waya;

  const RashiAyaWayaScreen({Key? key, required this.rashi_aya_waya}) : super(key: key);

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

    if (rashi_aya_waya.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: headerTextColor, // Adapt text color based on theme
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: cardColor, // Adapt card background color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'රාශී අය වැය',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: headerTextColor, // Adapt text color
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(
                color: borderColor!, // Adapt border color based on theme
                width: 1,
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: tableHeaderColor, // Adapt header background color
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
                          'රාශිය',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: headerTextColor, // Adapt text color for headers
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'අය',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: headerTextColor, // Adapt text color for headers
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'වැය',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: headerTextColor, // Adapt text color for headers
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                ...rashi_aya_waya.map((data) => TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.rashi,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tableRowTextColor, // Adapt row text color
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.aya,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tableRowTextColor, // Adapt row text color
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.waya,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tableRowTextColor, // Adapt row text color
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
