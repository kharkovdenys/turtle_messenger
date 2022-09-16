import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:uuid/uuid.dart';

class ChartRepository {
  Future addChatData(
      {required String message,
      required String chatId,
      required String senderId,
      List<String>? media}) async {
    Chatdata chat = Chatdata(
      media: media,
      createdAt: TemporalTimestamp.now(),
      updatedAt: TemporalTimestamp.now(),
      message: message,
      chatId: chatId,
      senderId: senderId,
    );
    await Amplify.DataStore.save(chat);
  }

  Future addGroupToChatList({required String name}) async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    Users user = (await Amplify.DataStore.query(Users.classType,
        where: Users.ID.eq(authUser.userId)))[0];
    String chatId = const Uuid().v4();
    Chat updateChatData =
        Chat(id: chatId, type: ChatType.GROUP, name: name, adminId: user.id);
    await Amplify.DataStore.save(updateChatData);
    await Amplify.DataStore.save(UserChat(users: user, chat: updateChatData));
  }

  Future addUserToChatList({required Users otherUser}) async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    Users user = (await Amplify.DataStore.query(Users.classType,
        where: Users.ID.eq(authUser.userId)))[0];
    String chatId = const Uuid().v4();
    Chat updateChatData = Chat(id: chatId, type: ChatType.PRIVATE);
    await Amplify.DataStore.save(updateChatData);
    await Amplify.DataStore.save(UserChat(users: user, chat: updateChatData));
    await Amplify.DataStore.save(
        UserChat(users: otherUser, chat: updateChatData));
  }

  Future deleteChats(List<String> messageIdList) async {
    for (String messageId in messageIdList) {
      Chatdata chatdata = (await Amplify.DataStore.query(Chatdata.classType,
          where: Chatdata.ID.eq(messageId)))[0];
      await Amplify.DataStore.delete(chatdata);
    }
  }

  Future<List<Chatdata>> getChatData({required String chatId}) async {
    List<Chatdata> chatData = await Amplify.DataStore.query(Chatdata.classType,
        where: Chatdata.CHATID.eq(chatId),
        sortBy: [Chatdata.CREATEDAT.descending()]);

    return chatData;
  }

  Future<List<UserChat>> getUserChatList() async {
    try {
      List<UserChat> data = [];
      Users? users = UserStore().currUser;
      if (users == null) return data;
      data = await Amplify.DataStore.query(UserChat.classType,
          where: UserChat.USERS.eq(users.id));
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future sendPhoto(File image, String key) async {
    try {
      S3UploadFileOptions options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);
      await Amplify.Storage.uploadFile(
          key: key, local: image, options: options);
    } on StorageException catch (_) {
      return "";
    }
  }

  Future updateChats(String messageId, String updatedMessage) async {
    Chatdata messagedata = (await Amplify.DataStore.query(Chatdata.classType,
        where: Chatdata.ID.eq(messageId)))[0];
    await Amplify.DataStore.save(messagedata.copyWith(message: updatedMessage));
  }
}
