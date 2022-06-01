import 'package:flutter/material.dart';
import 'package:turtle_messenger/views/screens/settings/settings_page.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/views/screens/chat/chat_page.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  late UserStore userStore;

  @override
  void initState() {
    userStore = context.read<UserStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: pageIndex,
        children: const [
          ChatPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getFooter() {
    List iconItems = [
      Icons.chat,
      Icons.settings,
    ];
    List textItems = ["Chats", "Settings"];
    return Container(
      height: 90,
      width: double.infinity,
      decoration: const BoxDecoration(color: greyColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            textItems.length,
                (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = index;
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      iconItems[index],
                      color:
                      pageIndex == index ? primary : white.withOpacity(0.5),
                      size: 29,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      textItems[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: pageIndex == index
                            ? primary
                            : white.withOpacity(0.5).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
