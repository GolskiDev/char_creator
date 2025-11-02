import 'package:flutter/material.dart';

class CharacterDeleteConfirmDialog {
  static Future<bool?> showDialog(BuildContext context) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Character'),
          content: Text('Are you sure you want to delete this character?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
