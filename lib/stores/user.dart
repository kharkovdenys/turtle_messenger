import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:turtle_messenger/repositories/user_repository.dart';
import 'package:turtle_messenger/models/Users.dart';

class UserStore extends ChangeNotifier {
  UserStore._();
  static final UserStore _instance = UserStore._();
  factory UserStore() => _instance;

  final UserRepository _userRepository = UserRepository();

  Users? currUser;
  List<Users>? allOtherUsers;

  Future fetchCurrentUser() async {
    currUser = await _userRepository.getCurrUser();
    notifyListeners();
  }

  Future fetchAllOtherUsers() async {
    allOtherUsers = await _userRepository.getAllOtherUses();
    notifyListeners();
  }
  Future updateProfileImage({required File image, required String key}) async {
    await _userRepository.updateProfileImage(image, key);
    notifyListeners();
  }
}
