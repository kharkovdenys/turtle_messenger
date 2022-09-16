import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/screens/chat/chat_detail_page.dart';
import 'package:turtle_messenger/views/screens/chat/chatdetails/add_chat.dart';
import 'package:turtle_messenger/views/screens/chat/group_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class UserChatCard extends StatefulWidget {
  final BuildContext context;
  final ChatType type;
  final Size size;
  final String? name;
  final String? adminId;
  final String chatId;
  final String currentId;

  const UserChatCard({
    Key? key,
    required this.context,
    required this.size,
    required this.name,
    required this.chatId,
    required this.type,
    required this.currentId,
    this.adminId,
  }) : super(key: key);

  @override
  State<UserChatCard> createState() => _UserChatCardState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatStore chatStore;
  late Stream<SubscriptionEvent<UserChat>> stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
    );
  }

  fetchUserChats() async {
    await chatStore.fetchUserChats();
    if (mounted) setState(() {});
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: 23,
                        color: white,
                        fontWeight: FontWeight.bold),
                  ),
                  MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateChat(),
                          ),
                        );
                      },
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 23))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
          child: Divider(color: white.withOpacity(0.3)),
        ),
        const SizedBox(
          height: 10,
        ),
        if (chatStore.userChats.isNotEmpty)
          Column(
            children: chatStore.userChats
                .map((user) => UserChatCard(
                      context: context,
                      size: size,
                      name: user.chat.name,
                      chatId: user.chat.id,
                      type: user.chat.type!,
                      currentId: user.users.id,
                      adminId: user.chat.adminId,
                    ))
                .toList(),
          ),
      ],
    );
  }

  handleSubscription(SubscriptionEvent<UserChat> event) async {
    if (event.item.users.id == UserStore().currUser!.id) {
      await chatStore.fetchUserChats();
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    chatStore = Provider.of<ChatStore>(context, listen: false);
    fetchUserChats();
    stream = Amplify.DataStore.observe(UserChat.classType)
      ..listen(handleSubscription);
    super.initState();
  }
}

class _UserChatCardState extends State<UserChatCard> {
  Chatdata lastMessage = Chatdata();
  String profileImage =
      "https://www.arrowbenefitsgroup.com/wp-content/uploads/2018/04/unisex-avatar.png";
  String nameChat = "";
  List<Users> users = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.type == ChatType.PRIVATE) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(
                name: nameChat,
                img: profileImage,
                chatId: widget.chatId,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GroupDetailPage(
                users: users,
                name: nameChat,
                adminId: widget.adminId!,
                chatId: widget.chatId,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(profileImage),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: SizedBox(
                height: 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (widget.size.width - 40) * 0.6,
                              child: Text(nameChat,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: white,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                              child: Text(
                                lastMessage.updatedAt != null
                                    ? DateFormat("dd/MM/yy").add_Hm().format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            lastMessage.updatedAt!.toSeconds() *
                                                1000))
                                    : "",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: white.withOpacity(0.4)),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: (widget.size.width - 40) * 0.8,
                      child: Text(
                          lastMessage.message != null
                              ? lastMessage.message!
                              : "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: white,
                          )),
                    ),
                    Divider(
                      color: white.withOpacity(0.3),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getUsers() async {
    List<UserChat> id = await Amplify.DataStore.query(UserChat.classType,
        where: UserChat.CHAT.eq(widget.chatId));
    for (int i = 0; i < id.length; i++) {
      if (id[i].users.id != widget.currentId) {
        Users temp = (await Amplify.DataStore.query(Users.classType,
            where: Users.ID.eq(id[i].users.id)))[0];
        users.add(temp);
      }
    }
    if (widget.type == ChatType.PRIVATE) {
      setState(() {
        nameChat = users[0].username!;
      });
      GetUrlResult value =
          await (Amplify.Storage.getUrl(key: users[0].username!));
      http.get(Uri.parse(value.url)).then((url) => setState(() {
            if (url.statusCode != 404) {
              setState(() {
                profileImage = value.url;
              });
            }
          }));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == ChatType.PRIVATE) {
      getUsers();
    } else {
      setState(() {
        nameChat = widget.name!;
      });
      getUsers();
    }
    ChatStore().lastMessage(widget.chatId).then((result) {
      setState(() {
        lastMessage = result;
      });
    });
  }
}
