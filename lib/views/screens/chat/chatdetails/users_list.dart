import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:turtle_messenger/models/ModelProvider.dart';

import '../../../widgets/snackbars.dart';


class UsersList extends StatefulWidget {
  final Users user;

  const UsersList({Key? key, required this.user})
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
                              bool using=false;
                              List<UserChat> user = await Amplify.DataStore.query(UserChat.classType,
                                  where: UserChat.USERS.eq(widget.user.id));
                              String myid=UserStore().currUser!.id;
                              for(int i=0;i<user.length;i++){
                                List<UserChat> temp = await Amplify.DataStore.query(UserChat.classType,
                                    where: UserChat.CHAT.eq(user[i].chat.id).and(UserChat.USERS.eq(myid)));
                                if(temp.isNotEmpty){
                                  using=true;
                                }
                              }
                              if (!using) {
                                setState(() {
                                  addButtonLoading = true;
                                });
                                await ChatStore().addUserToChatList(widget.user);
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
