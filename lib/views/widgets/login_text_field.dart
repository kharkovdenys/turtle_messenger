import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle_messenger/services/size_config.dart';
import 'package:turtle_messenger/theme/colors.dart';

class CustomLoginTextField extends StatelessWidget {
  final String hintTextL;
  final TextEditingController ctrl;
  final Function validation;
  final bool obscureText;
  final TextInputType type;
  final String? autofill;
  final int? maxLength;
  const CustomLoginTextField(
      {Key? key,
      required this.hintTextL,
      required this.ctrl,
      required this.validation,
      this.autofill,
      this.obscureText = false,
      required this.type,
      this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => validation(value),
      controller: ctrl,
      obscureText: obscureText,
      keyboardType: type,
      maxLength: maxLength,
      autofillHints: autofill != null ? [autofill!] : null,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!, width: 2.toWidth),
          borderRadius: BorderRadius.all(
            Radius.circular(18.toWidth),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!, width: 2.toWidth),
          borderRadius: BorderRadius.all(
            Radius.circular(18.toWidth),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColor.primary, width: 2.toWidth),
          borderRadius: BorderRadius.all(
            Radius.circular(18.toWidth),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!, width: 2.toWidth),
          borderRadius: BorderRadius.all(
            Radius.circular(18.toWidth),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18.toWidth,
          vertical: 16.toHeight,
        ),
        hintText: hintTextL,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 18.toFont,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16.toFont,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
