import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/repositories/chat_repository.dart';

class ChatStore extends ChangeNotifier {
  static final ChatStore _instance = ChatStore._();
  List<UserChat> userChats = [];
  List<Chatdata> chatData = [];

  final ChartRepository _chartRepository = ChartRepository();
  factory ChatStore() => _instance;
  ChatStore._();

  Future addChatData({
    required String message,
    required String chatId,
    required String senderId,
    List<String>? media,
  }) async {
    await _chartRepository.addChatData(
        message: message, chatId: chatId, senderId: senderId, media: media);
    notifyListeners();
  }

  Future addGroupToChatList(String name) async {
    await _chartRepository.addGroupToChatList(name: name);
    notifyListeners();
  }

  addUpdatedChats(Chatdata updatedChatData) {
    chatData.insert(0, updatedChatData);
    notifyListeners();
  }

  Future addUserToChatList(Users otherUser) async {
    await _chartRepository.addUserToChatList(otherUser: otherUser);
    notifyListeners();
  }

  Future deleteChats(List<String> messageIdList) async {
    await _chartRepository.deleteChats(messageIdList);
    notifyListeners();
  }

  Future fetchChatData(String chatId) async {
    chatData = await _chartRepository.getChatData(chatId: chatId);
    notifyListeners();
  }

  Future fetchUserChats() async {
    userChats = await _chartRepository.getUserChatList();
    notifyListeners();
  }

  Future<Chatdata> getMessage(String id) async {
    Chatdata messageData = (await Amplify.DataStore.query(Chatdata.classType,
        where: Chatdata.ID.eq(id)))[0];
    return messageData;
  }

  Future<Chatdata> lastMessage(String chatId) async {
    Chatdata messageData;
    try {
      messageData = (await Amplify.DataStore.query(Chatdata.classType,
          where: Chatdata.CHATID.eq(chatId),
          sortBy: [Chatdata.CREATEDAT.descending()]))[0];
    } catch (e) {
      messageData = Chatdata(message: "No messages yet");
    }
    return messageData;
  }

  resetChatData() {
    chatData = [];
    userChats = [];
    notifyListeners();
  }

  Future sendPhoto(File image, String key) async {
    await _chartRepository.sendPhoto(image, key);
    notifyListeners();
  }

  Future updateChat(String messageId, String updatedMessage) async {
    await _chartRepository.updateChats(messageId, updatedMessage);
    notifyListeners();
  }
}
