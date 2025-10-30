import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

/// Show a custom flushbar using `another_flushbar`.
/// - [message]: the message to display (required)
/// - [isError]: if true shows error styling, otherwise success/info styling
/// - [duration]: optional override for how long the bar stays visible
void showCustomFlushbar(
  BuildContext context, {
  required String message,
  bool isError = false,
  Duration? duration,
  String? title,
}) {
  final bgColor = isError ? Colors.red.shade600 : Colors.green.shade700;
  final icon = isError ? Icons.error_outline : Icons.check_circle_outline;
  final defaultDuration = duration ?? const Duration(seconds: 3);

  Flushbar(
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: bgColor,
    flushbarPosition: FlushbarPosition.TOP,
    duration: defaultDuration,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    leftBarIndicatorColor: isError ? Colors.redAccent : Colors.greenAccent,
    icon: Icon(icon, color: Colors.white),
    titleText: title != null
        ? Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          )
        : null,
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),
    // Optional: add an action button (uncomment to enable)
    // mainButton: TextButton(
    //   onPressed: () { /* do something */ },
    //   child: const Text('UNDO', style: TextStyle(color: Colors.white70)),
    // ),
  ).show(context);
}
