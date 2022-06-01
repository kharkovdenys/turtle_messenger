import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/models/Users.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/views/screens/settings/components/image_picker.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final NavigationService _navigationService = get_it_instance_const<NavigationService>();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  bool addButtonloading = false;
  String profileImage="https://www.arrowbenefitsgroup.com/wp-content/uploads/2018/04/unisex-avatar.png";
  Users? currUser;

  Future _onRefresh() async {
    await UserStore().fetchCurrentUser();
    await UserStore().fetchAllOtherUsers();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    setState((){currUser=UserStore().currUser;});
    setStateProfileImage();
  }
  void setStateProfileImage(){
    (Amplify.Storage.getUrl(key: currUser!.username!).then((value) =>
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
    return Scaffold(
      backgroundColor: bgColor,
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: const MaterialClassicHeader(color: Colors.white),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: getBody(),
      ),
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
        buildUserSection(currUser),
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
                buildListItem(
                  title: "Logout",
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

  Container buildUserSection(Users? currUser) {
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
                    image: currUser == null
                        ? null
                        : DecorationImage(
                            image: CachedNetworkImageProvider(profileImage),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  currUser == null ? "" : currUser.username!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ],
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: white.withOpacity(0.1), shape: BoxShape.circle),
              child: ImagePickerButton(username: currUser!.username!,image:setStateProfileImage),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildListItem({required String title, required IconData icon, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: white.withOpacity(0.2),
            size: 15,
          )
        ],
      ),
    );
  }
}
