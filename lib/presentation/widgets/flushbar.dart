import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushBar(BuildContext context, String message,
    {Color backgroundColor = Colors.black}) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 3),
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    icon: const Icon(
      Icons.info_outline,
      color: Colors.white,
    ),
  ).show(context);
}
