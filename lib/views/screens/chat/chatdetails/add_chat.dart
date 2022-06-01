import 'package:flutter/material.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/views/widgets/add_group.dart';
import '../../../../stores/auth.dart';
import '../../../../stores/user.dart';
import '../../../widgets/primary_button.dart';
import 'users_list.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({Key? key}) : super(key: key);

  @override
  _CreateChatState createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
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
              "Add new chat",
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
                    return UsersList(user: user);
                  }).toList()
                ],
              );
            }
          }),
          const SizedBox(height: 30,),
          PrimaryButton(
            onPress: (){addGroup(context);},
            text: 'Add group',
          )
        ]));
  }
}
