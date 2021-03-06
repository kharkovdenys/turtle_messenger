import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:turtle_messenger/views/widgets/snackbars.dart';
import 'package:turtle_messenger/views/widgets/update_message_bottom_sheet.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/views/screens/chat/ChatDetails/appbar.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart' as color;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String img;
  final String chatId;

  const ChatDetailPage({
    Key? key,
    required this.name,
    required this.img,
    required this.chatId,
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController messageCtrl = TextEditingController();
  late Stream<SubscriptionEvent<Chatdata>> stream;
  Map<String,String> image={};
  bool inSelectMode = false;
  List<String> selectedChats = [];

  late UserStore userStore;
  late ChatStore chatStore;

  @override
  void initState() {
    super.initState();
    chatStore = Provider.of<ChatStore>(context, listen: false);
    userStore = Provider.of<UserStore>(context, listen: false);
    fetchChatData();
    stream = Amplify.DataStore.observe(Chatdata.classType)
      ..listen(handleSubscription);
  }

  addToSelectedChats(String messageId) {
    if (selectedChats.contains(messageId)) {
      selectedChats.remove(messageId);
      if (selectedChats.isEmpty) {
        setState(() {
          inSelectMode = false;
        });
      }
    } else {
      selectedChats.add(messageId);
    }
  }

  closeSelectionModel() {
    setState(() {
      inSelectMode = false;
      selectedChats = [];
    });
  }

  deleteSelectedChats() async {
    await chatStore.deleteChats(selectedChats);
    await fetchChatData();
    setState(() {
      inSelectMode = false;
      selectedChats = [];
    });
  }

  openUpdateMessageSheet() async {
    if (selectedChats.length > 1) {
      showErrorSnackBar(context, "Please select only one message to update.");
    } else {
      Chatdata message = await chatStore.getMessage(selectedChats[0]);
      updateMessageBottomSheet(
          context, message, chatStore.updateChat, closeSelectionModel);
    }
  }

  fetchChatData() async {
    await chatStore.fetchChatData(widget.chatId);
    if (mounted) setState(() {});
  }

  handleSubscription(SubscriptionEvent<Chatdata> event) async {
    if (event.eventType == EventType.delete) {
      fetchChatData();
    } else if (event.eventType == EventType.update) {
      fetchChatData();
    } else if (event.eventType == EventType.create) {
      if (chatStore.chatData.last.id != event.item.id &&
          event.item.chatId == chatStore.chatData.last.chatId &&
          event.item.senderId != userStore.currUser?.id) {
        if (mounted) {
          setState(() {
            chatStore.addUpdatedChats(event.item);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.bgColor,
      appBar: getChatDetailsAppBar(
        context: context,
        img: widget.img,
        name: widget.name,
        inSelectMode: inSelectMode,
        selectedChatCount: selectedChats.length,
        closeSelectionModel: closeSelectionModel,
        deleteSelectedChats: deleteSelectedChats,
        openUpdateMessageSheet: openUpdateMessageSheet,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Container(
      child: buildChatList(chatData: chatStore.chatData),
    );
  }

  void uploadFile() async {
    XFile? pickResult = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (pickResult == null) return;
    File? image = File(pickResult.path);
    List<String> media = [];
    String uuid = const Uuid().v4();
    await chatStore.sendPhoto(image, uuid);
    media.add(uuid);
    chatStore.addUpdatedChats(
      Chatdata(
        chatId: widget.chatId,
        message: "",
        media: media,
        senderId: userStore.currUser?.id,
        createdAt: TemporalTimestamp.now(),
        updatedAt: TemporalTimestamp.now(),
        id: const Uuid().v4(),
      ),
    );
    await chatStore.addChatData(
        message: "",
        media: media,
        chatId: widget.chatId,
        senderId: userStore.currUser!.id);
    if (mounted) setState(() {});
    fetchChatData();
  }
urlImage(String value){
    if(image[value]==null) {
      (Amplify.Storage.getUrl(key: value).then((result) => setState(() {
        image[value] = result.url.replaceFirst('https', 'http');
      })));
    }
  return image[value]??"https://www.rentaltss.com/images/Videosvet/background_gray.jpg";
}
  Widget buildChatList({required List<Chatdata> chatData}) {
    return DashChat(
        inputOptions: InputOptions(
          leading: <Widget>[
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.attach_file),
              onPressed: uploadFile,
            )
          ],
        ),
        messages: List.generate(chatData.length, (index) {
          return ChatMessage(
              medias: List.generate(
                  chatData[index].media == null ? 0 : chatData[index].media!.length,
                  (number) => ChatMedia(
                      url: urlImage(chatData[index].media![number]),
                      fileName: '',
                      type: MediaType.image)),
              user: ChatUser(id: chatData[index].senderId!),
              text: chatData[index].message!,
              customProperties: {"id": chatData[index].id},
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                  chatData[index].createdAt!.toSeconds() * 1000));
        }),
        onSend: (ChatMessage message) async {
          chatStore.addUpdatedChats(
            Chatdata(
              chatId: widget.chatId,
              message: message.text,
              senderId: userStore.currUser?.id,
              createdAt: TemporalTimestamp.now(),
              updatedAt: TemporalTimestamp.now(),
              id: const Uuid().v4(),
            ),
          );
          await chatStore.addChatData(
              message: message.text,
              chatId: widget.chatId,
              senderId: userStore.currUser!.id);
          if (mounted) setState(() {});
          fetchChatData();
        },
        currentUser: ChatUser(id: userStore.currUser!.id),
        messageOptions: MessageOptions(
          showOtherUsersAvatar: false,
          onLongPressMessage: (ChatMessage message) {
            if (message.user.id == userStore.currUser!.id) {
              if (!inSelectMode) {
                setState(() {
                  inSelectMode = true;
                  addToSelectedChats(message.customProperties!["id"]);
                });
              } else {
                setState(() {
                  addToSelectedChats(message.customProperties!["id"]);
                });
              }
            }
          },
          onPressMessage: (ChatMessage message) {
            if (inSelectMode) {
              setState(() {
                addToSelectedChats(message.customProperties!["id"]);
              });
            }
          },
          onTapMedia: (ChatMedia media){
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroPhotoViewRouteWrapper(
                imageProvider: CachedNetworkImageProvider(
                  media.url,
                ),
              ),
            ),
          );},
          messageDecorationBuilder: (ChatMessage message,
              ChatMessage? previousMessage, ChatMessage? nextMessage) {
            return BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: message.user.id == userStore.currUser!.id
                  ? selectedChats.contains(message.customProperties!["id"])
                      ? Theme.of(context).primaryColor.withOpacity(0.5)
                      : Theme.of(context).primaryColor
                  : Colors.grey[200], // example
            );
          },
        ));
  }
}
class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery
            .of(context)
            .size
            .height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }}