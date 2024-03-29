import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/models/Users.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/screens/chat/chatdetails/users_list.dart';
import 'package:turtle_messenger/views/widgets/add_group.dart';
import 'package:turtle_messenger/views/widgets/primary_button.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({Key? key}) : super(key: key);

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
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
              "Add new chat",
              style: TextStyle(
                  fontSize: 23, color: white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          getList(),
          const SizedBox(
            height: 30,
          ),
          PrimaryButton(
            onPress: () {
              addGroup(context);
            },
            text: 'Add group',
          )
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
            return UsersList(user: user);
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
