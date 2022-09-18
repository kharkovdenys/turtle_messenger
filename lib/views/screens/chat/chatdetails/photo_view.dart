import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  final ImageProvider imageProvider;

  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  const HeroPhotoViewRouteWrapper({
    Key? key,
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
