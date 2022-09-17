import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:turtle_messenger/amplifyconfiguration.dart';
import 'package:turtle_messenger/models/ModelProvider.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/stores/user.dart';

void configureAmplify() async {
  NavigationService navigationService = getItInstanceConst<NavigationService>();
  AmplifyAuthCognito auth = AmplifyAuthCognito();
  AmplifyDataStore datastorePlugin = AmplifyDataStore(
    modelProvider: ModelProvider.instance,
  );
  AmplifyAPI apiPlugin = AmplifyAPI();
  AmplifyStorageS3 storage = AmplifyStorageS3();
  await Amplify.addPlugins([auth, datastorePlugin, apiPlugin, storage]);
  bool isSignedIn = false;
  try {
    await Amplify.configure(amplifyconfig);
    isSignedIn = await _isSignedIn();
  } catch (_) {}
  if (isSignedIn) {
    await UserStore().fetchCurrentUser();
    await UserStore().fetchAllOtherUsers();
    navigationService.popAllAndReplace(RoutePath.home);
  } else {
    navigationService.popAllAndReplace(RoutePath.login);
  }
}

Future<bool> _isSignedIn() async {
  final session = await Amplify.Auth.fetchAuthSession();
  return session.isSignedIn;
}
