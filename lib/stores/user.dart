import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:turtle_messenger/models/Users.dart';
import 'package:turtle_messenger/repositories/user_repository.dart';

class UserStore extends ChangeNotifier {
  static final UserStore _instance = UserStore._();
  final UserRepository _userRepository = UserRepository();
  Users? currUser;

  List<Users>? allOtherUsers;

  factory UserStore() => _instance;
  UserStore._();

  Future fetchAllOtherUsers() async {
    allOtherUsers = await _userRepository.getAllOtherUses();
    notifyListeners();
  }

  Future fetchCurrentUser() async {
    currUser = await _userRepository.getCurrUser();
    notifyListeners();
  }

  Future updateProfileImage({required File image, required String key}) async {
    await _userRepository.updateProfileImage(image, key);
    notifyListeners();
  }
}
