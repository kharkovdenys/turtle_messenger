import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/screens/settings/components/image_picker.dart';

Widget buildUserSection(
    Users currUser, String profileImage, Function setStateProfileImage) {
  return Container(
    width: double.infinity,
    height: 90,
    decoration: const BoxDecoration(color: textfieldColor),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: profileImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                currUser.username!,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: white),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: white.withOpacity(0.1), shape: BoxShape.circle),
            child: ImagePickerButton(
                username: currUser.username!, image: setStateProfileImage),
          )
        ],
      ),
    ),
  );
}
