import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:provider/provider.dart';
import '../../../../models/Chat.dart';
import '../../../../models/UserChat.dart';
import '../../../../models/Users.dart';
import '../../../../stores/auth.dart';
import '../../../../stores/chat.dart';
import '../../../../stores/user.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/snackbars.dart';

class AddUser extends StatefulWidget {
  final List<Users> users;
  final String chatId;
  const AddUser({Key? key, required this.users, required this.chatId}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: ListView(children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 30),
            child: Text(
              "Add a new user to the group",
              style: TextStyle(
                  fontSize: 23, color: white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer2<UserStore, AuthStore>(
              builder: (_, userStore, authStore, __) {
                if (userStore.allOtherUsers == null) {
                  return Container();
                } else if (userStore.allOtherUsers!.isEmpty) {
                  return const Text("Sorry there is no other user.");
                } else {
                  return Column(
                    children: [
                      ...userStore.allOtherUsers!.map((user) {
                        return UsersList(user: user,users:widget.users,chatId: widget.chatId,);
                      }).toList()
                    ],
                  );
                }
              }),
        ]));
  }
}
class UsersList extends StatefulWidget {
  final Users user;
  final List<Users> users;
  final String chatId;

  const UsersList({Key? key, required this.user, required this.users, required this.chatId})
      : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool addButtonLoading = false;
  String profileImage =
      "https://www.arrowbenefitsgroup.com/wp-content/uploads/2018/04/unisex-avatar.png";

  @override
  void initState() {
    super.initState();
    setStateProfileImage();
  }

  void setStateProfileImage() {
    (Amplify.Storage.getUrl(key: widget.user.username!).then((value) =>
        http.get(Uri.parse(value.url)).then((url) => setState(() {
          if (url.statusCode != 404) {
            setState(() {
              profileImage = value.url;
            });
          }
        }))));
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(profileImage),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.user.username!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: white.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(
                    child: addButtonLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                      color: primary,
                      onPressed: () async {
                        if (!widget.users.contains(widget.user)) {
                          setState(() {
                            addButtonLoading = true;
                          });
                          Chat chat = (await Amplify.DataStore.query(Chat.classType,
                              where: Chat.ID.eq(widget.chatId)))[0];
                          await Amplify.DataStore.save(UserChat(users: widget.user,chat: chat));
                          await UserStore().fetchCurrentUser();
                          await ChatStore().fetchUserChats();
                          setState(() {
                            addButtonLoading = false;
                          });
                        }
                        else{
                          showErrorSnackBar(context,"This user has already been added");
                        }
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
