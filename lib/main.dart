import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/routes/routes_generator.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/amplify.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';

void main() {
  GetItService.setupLocator();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          home: Container(),
          theme: ThemeData(
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.black,
          ))),
          navigatorKey: getItInstanceConst<NavigationService>().navigatorKey,
          onGenerateRoute: generateRoute,
          initialRoute: RoutePath.wrapper,
        ));
  }

  @override
  void initState() {
    super.initState();
    configureAmplify();
  }
}
