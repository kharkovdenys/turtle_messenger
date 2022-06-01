import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:turtle_messenger/models/Users.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';



class UserRepository {
  late Users currentUser;

  Future<bool?> login({
    required String username,
    required String password,
  }) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      try{
        (await Amplify.DataStore.query(Users.classType,where: Users.ID.eq(authUser.userId)))[0];
      }
      catch(e){
        Amplify.DataStore.save(
          Users(
            username: username,
            bio: "",
            id: authUser.userId,
            createdAt: TemporalTimestamp.now(),
          ),
        );
      }
      return res.isSignedIn;

    } on UserNotConfirmedException catch (_) {
      return null;
    } catch(e){
      return false;
    }
  }
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    var userAttributes = {CognitoUserAttributeKey.email: email};
    try {
      var res = await Amplify.Auth.signUp(
          username: username,
          password: password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      return res.isSignUpComplete;
    }
    catch (e) {
      rethrow;
    }
  }

  Future<bool> confirm({
    required String username,
    required String email,
    required String password,
    required String otp,
  }) async {
    SignUpResult res = await Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: otp,
    );
    if (res.isSignUpComplete) {
      SignInResult signInRes = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      Amplify.DataStore.save(
        Users(
          username: username,
          bio: "",
          id: authUser.userId,
          createdAt: TemporalTimestamp.now(),
        ),
      );
      return signInRes.isSignedIn;
    }
    return false;
  }
  Future<bool> confirmSignedIn({
    required String username,
    required String otp,
  }) async {
    SignUpResult res = await Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: otp,
    );
    return res.isSignUpComplete;
  }

  Future logout() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (_) {
      rethrow;
    }
  }
  Future resend({required String username}) async {
    try {
      await Amplify.Auth.resendSignUpCode(
        username: username,
      );
    } on AuthException catch (_) {
      rethrow;
    }
  }
  Future<Users?> getCurrUser() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    List<Users> user = await Amplify.DataStore.query(Users.classType,
        where: Users.ID.eq(authUser.userId));
    if (user.isNotEmpty) {
      return user.first;
    } else {
      return null;
    }
  }
  Future<List<Users>> getAllOtherUses() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    List<Users> users = await Amplify.DataStore.query(Users.classType,
        where: Users.ID.ne(authUser.userId));
    return users;
  }
  Future<bool> isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }
  Future updateProfileImage(File image, String key) async {
    try {
      await Amplify.Storage.remove(key: key);
      S3UploadFileOptions options = S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);
      await Amplify.Storage.uploadFile(
          key: key,
          local: image,
          options: options);
      } on StorageException catch (e) {
      print(e.message);
    }
  }
}
