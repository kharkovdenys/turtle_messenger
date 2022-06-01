import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/routes/routes_generator.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/wrapper.dart';
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  GetItService.setupLocator();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
  ));
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NavigationService _navigationService =
      get_it_instance_const<NavigationService>();
  late AmplifyAuthCognito auth;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    auth = AmplifyAuthCognito();
    AmplifyDataStore datastorePlugin = AmplifyDataStore(
      modelProvider: ModelProvider.instance,
    );
    AmplifyAPI apiPlugin = AmplifyAPI();
    AmplifyStorageS3 storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, datastorePlugin, apiPlugin,storage]);
    bool isSignedIn = false;
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          'Amplify was already configured. Looks like app restarted on android.');
    }
    try {
      isSignedIn = await _isSignedIn();
    } on AmplifyException {
      print('User is not signed in.');
    }
    if (isSignedIn) {
      await UserStore().fetchCurrentUser();
      await UserStore().fetchAllOtherUsers();
      _navigationService.popAllAndReplace(RoutePath.home);
    } else {
      _navigationService.popAllAndReplace(RoutePath.login);
    }
    FlutterNativeSplash.remove();
  }

  Future<bool> _isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatStore>(
            create: (_) => ChatStore(),
            lazy: false,
          ),
          ChangeNotifierProvider<UserStore>(
            create: (_) => UserStore(),
            lazy: false,
          ),
          ChangeNotifierProvider<AuthStore>(
            create: (_) => AuthStore(),
            lazy: false,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Wrapper(),
          theme: ThemeData(
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.black,
              ))),
          navigatorKey: get_it_instance_const<NavigationService>().navigatorKey,
          onGenerateRoute: generateRoute,
          initialRoute: RoutePath.wrapper,
        ));
  }
}
