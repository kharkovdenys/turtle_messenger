import 'package:flutter/material.dart';
import 'package:turtle_messenger/theme/colors.dart';

Widget buildButton(
    {required String title,
    required IconData icon,
    required Function() onTap,
    required Color color}) {
  return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            ),
            child: Center(
              child: Icon(
                icon,
                color: white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: white,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ));
}
