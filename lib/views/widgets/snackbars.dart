import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.redAccent,
    ),
  );
}
