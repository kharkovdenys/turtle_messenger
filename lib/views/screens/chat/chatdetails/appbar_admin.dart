import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/theme/colors.dart';

PreferredSizeWidget getAdminDetailsAppBar({
  required BuildContext context,
  required String img,
  required String name,
  required bool inSelectMode,
  required int selectedChatCount,
  required Function closeSelectionModel,
  required Function deleteSelectedChats,
  required Function openUpdateMessageSheet,
  required Function addUsers,
}) =>
    AppBar(
      backgroundColor: greyColor,
      title: inSelectMode
          ? Text(selectedChatCount.toString())
          : Row(
              children: [
                Container(
                  width: 36,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(img),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
      leading: inSelectMode
          ? GestureDetector(
              onTap: () {
                closeSelectionModel();
              },
              child: const Icon(
                Icons.cancel_outlined,
              ),
            )
          : GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
      actions: inSelectMode
          ? [
              IconButton(
                  icon: const Icon(Icons.edit, size: 30),
                  onPressed: () async {
                    await openUpdateMessageSheet();
                  }),
              const SizedBox(width: 20),
              IconButton(
                  icon: const Icon(Icons.delete, size: 30),
                  onPressed: () async {
                    await deleteSelectedChats();
                  }),
              const SizedBox(width: 20),
            ]
          : [
              IconButton(
                  icon: const Icon(Icons.add, size: 30),
                  onPressed: () async {
                    await addUsers();
                  }),
            ],
    );
