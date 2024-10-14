import 'package:flutter/material.dart';

class PlaceholderMessage extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const PlaceholderMessage({required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100],
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black54),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
