import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/screens/chat/chatdetails/users_list.dart';

class AddUser extends StatefulWidget {
  final List<Users> users;
  final String chatId;
  const AddUser({Key? key, required this.users, required this.chatId})
      : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late UserStore userStore;
  late Stream<SubscriptionEvent<Users>> stream;

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
          getList(),
        ]));
  }

  Widget getList() {
    if (userStore.allOtherUsers == null) {
      return Container();
    } else if (userStore.allOtherUsers!.isEmpty) {
      return const Text("Sorry there is no other user.");
    } else {
      return Column(
        children: [
          ...userStore.allOtherUsers!.map((user) {
            return UsersList(
                user: user, users: widget.users, chatId: widget.chatId);
          }).toList()
        ],
      );
    }
  }

  @override
  void initState() {
    userStore = Provider.of<UserStore>(context, listen: false);
    userStore.fetchAllOtherUsers();
    stream = Amplify.DataStore.observe(Users.classType)
      ..listen(handleSubscription);
    super.initState();
  }

  handleSubscription(SubscriptionEvent<Users> event) async {
    await userStore.fetchAllOtherUsers();
    if (mounted) setState(() {});
  }
}
