import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:turtle_messenger/repositories/user_repository.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';

class AuthStore extends ChangeNotifier {
  AuthStore._();
  static final AuthStore _instance = AuthStore._();
  factory AuthStore() {
    return _instance;
  }

  bool? isAuthenticated;

  final UserRepository _userRepository = UserRepository();

  Future isSignedIn() async {
    AuthSession authSessions = await Amplify.Auth.fetchAuthSession();
    isAuthenticated = authSessions.isSignedIn;
    notifyListeners();
  }

  Future<bool?> login({
    required String username,
    required String password,
  }) async {
    try {
      bool? isSignInComplete = await UserRepository().login(
        password: password, username: username,
      );
      if (isSignInComplete!=null&&isSignInComplete) {
        await UserStore().fetchCurrentUser();
        await UserStore().fetchAllOtherUsers();
        return true;
      }
      return isSignInComplete;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({
    required name,
    required email,
    required password,
  }) async {
    try {
      bool isSignupComplete = await _userRepository.register(
        email: email,
        password: password,
        username: name,
      );
      return isSignupComplete;
    } catch (e) {
      return false;
    }
  }
  Future<bool> confirm({
    required String username,
    required String email,
    required String otp,
    required String password,
  }) async {
    bool isVerified = await _userRepository.confirm(
      username: username,
      email: email,
      otp: otp,
      password: password,
    );
    if (isVerified) {
      await UserStore().fetchCurrentUser();
      await UserStore().fetchAllOtherUsers();
    }
    return isVerified;
  }
  Future<bool> confirmSignedIn({
    required String username,
    required String otp,
  }) async {
    bool isVerified = await _userRepository.confirmSignedIn(
      username: username,
      otp: otp,
    );
    return isVerified;
  }
  Future logout() async {
    await _userRepository.logout();
    ChatStore().resetChatData();
    notifyListeners();
  }

  Future resend({required String username}) async {
    try {
      await _userRepository.resend(username: username);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
