import 'package:flutter/material.dart';
import 'package:turtle_messenger/services/size_config.dart';

class SecondaryButton extends StatefulWidget {
  final String text;
  final Function() onPress;
  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  MaterialStateProperty<Color> backgroundColor =
      MaterialStateProperty.all(Colors.black);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: 50.toHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: widget.onPress,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.black),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 20.toFont,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
