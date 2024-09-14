import 'package:flutter/material.dart';

class KonaMasaWidget extends StatelessWidget {
  final List<String> konaMasa;

  const KonaMasaWidget({Key? key, required this.konaMasa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (konaMasa.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(
                color: Colors.grey.shade300,
                width: 1,
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'කෝණ මාස',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                ...konaMasa.map((data) => TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data,
                              textAlign: TextAlign.center,
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
