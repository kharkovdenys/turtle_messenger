import 'package:flutter/material.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/views/screens/authentication/confirm_screen.dart';
import 'package:turtle_messenger/views/screens/authentication/login_screen.dart';
import 'package:turtle_messenger/views/screens/authentication/register_screen.dart';
import 'package:turtle_messenger/views/screens/home.dart';
import 'package:turtle_messenger/wrapper.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutePath.wrapper:
      return MaterialPageRoute(builder: (_) => const Wrapper());

    case RoutePath.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case RoutePath.register:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());

    case RoutePath.confirm:
      Map<String, String> arguments = settings.arguments as Map<String, String>;
      return MaterialPageRoute(
        builder: (_) => ConfirmScreen(
          username: arguments['username']!,
          email: arguments['email']!,
          password: arguments['password']!,
        ),
      );

    case RoutePath.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());

    default:
      return MaterialPageRoute(builder: (_) => const Wrapper());
  }
}
