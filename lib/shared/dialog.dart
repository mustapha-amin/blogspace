import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmLabel,
  required VoidCallback onConfirm,
  String? cancelLabel,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        constraints: BoxConstraints(minWidth: 500),
        content: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(content),
        ),
        actions: [
          ShadButton.outline(
            child: Text(cancelLabel ?? 'Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ShadButton(
            child: Text(confirmLabel ?? 'Continue'),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}
