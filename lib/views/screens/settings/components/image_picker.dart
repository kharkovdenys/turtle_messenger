import 'dart:io';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turtle_messenger/stores/user.dart';

class ImagePickerButton extends StatefulWidget {
  final String username;
  final Function image;
  const ImagePickerButton({Key? key, required this.username, required this.image}) : super(key: key);
  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final picker = ImagePicker();
  File? _image;
  Future getImage() async {
    XFile? pickResult = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 20,maxHeight: 200,maxWidth: 200);
    if (pickResult == null) {
      print('User canceled upload.');
      return;
    }
    _image = File(pickResult.path);
    await UserStore().updateProfileImage(image: _image!, key: widget.username);
    widget.image();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          getImage();
        },
        icon: const Icon(
          Icons.edit,
          color: primary,
          size: 20,
        ),
      ),
    );
  }
}
