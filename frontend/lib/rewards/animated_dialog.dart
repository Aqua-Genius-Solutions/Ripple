import 'package:flutter/material.dart';

class AnimatedDialog extends StatelessWidget {
  final String message;
  final VoidCallback onOkPressed;

  AnimatedDialog({required this.message, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.blue[200], // Water-like background color
      title: Text(
        'Reward',
        style: TextStyle(color: Colors.white), // White text color
      ),
      content: Text(
        message,
        style: TextStyle(color: Colors.white), // White text color
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onOkPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[300], // Water-like button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white), // White text color
          ),
        ),
      ],
    );
  }
}