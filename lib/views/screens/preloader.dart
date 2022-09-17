import 'package:flutter/material.dart';
import 'package:turtle_messenger/services/size_config.dart';

class Preloader extends StatefulWidget {
  const Preloader({Key? key}) : super(key: key);
  @override
  State<Preloader> createState() => _PreloaderState();
}

class _PreloaderState extends State<Preloader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Image.asset("assets/images/background.png");
  }
}
