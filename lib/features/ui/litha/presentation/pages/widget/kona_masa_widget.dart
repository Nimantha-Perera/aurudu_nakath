import 'package:flutter/material.dart';

class KonaMasaWidget extends StatelessWidget {
  final List<String> konaMasa;

  KonaMasaWidget({required this.konaMasa});

  @override
  Widget build(BuildContext context) {
    if (konaMasa.isEmpty) {
      return Center(child: Text('No data available'));
    }
    return Column(
      children: konaMasa
          .map((data) => ListTile(
                title: Text(data),
              ))
          .toList(),
    );
  }
}
