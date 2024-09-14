import 'package:aurudu_nakath/features/ui/litha/domain/entities/maru_sitina_disawa.dart';
import 'package:flutter/material.dart';

class MaruSitinaDisawaWidget extends StatelessWidget {
  final List<MaruSitinaDisawa> maruSitinaDisawa;

  const MaruSitinaDisawaWidget({Key? key, required this.maruSitinaDisawa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (maruSitinaDisawa.isEmpty) {
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
            const Text(
              'මරු සිටින දිශාව',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
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
                          'දවස',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'දිශාව',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                ...maruSitinaDisawa.map((data) => TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.dawasa,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              data.disawa,
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