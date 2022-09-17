import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turtle_messenger/models/Users.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/screens/settings/components/button.dart';
import 'package:turtle_messenger/views/screens/settings/components/user_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final NavigationService _navigationService =
      getItInstanceConst<NavigationService>();
  String profileImage =
      "https://www.arrowbenefitsgroup.com/wp-content/uploads/2018/04/unisex-avatar.png";
  late Users currUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 30),
          child: Text(
            "Settings",
            style: TextStyle(
                fontSize: 23, color: white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        buildUserSection(currUser, profileImage, setStateProfileImage),
        const SizedBox(
          height: 30,
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: textfieldColor),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            child: Column(
              children: [
                buildButton(
                  title: "Logout",
                  color: Colors.red,
                  icon: Icons.logout,
                  onTap: () async {
                    await AuthStore().logout();
                    _navigationService.popAllAndReplace(RoutePath.login);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currUser = UserStore().currUser!;
    });
    setStateProfileImage();
  }

  void setStateProfileImage() {
    (Amplify.Storage.getUrl(key: currUser.username!).then(
        (value) => http.get(Uri.parse(value.url)).then((url) => setState(() {
              if (url.statusCode != 404) {
                setState(() {
                  profileImage = value.url;
                });
              }
            }))));
  }
}
