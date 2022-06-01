import 'package:flutter/material.dart';
import 'package:turtle_messenger/services/size_config.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final void Function() onPress;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: 50.toHeight,
      child: TextButton(
        onPressed: widget.onPress,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0.toWidth),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 20.toFont,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
