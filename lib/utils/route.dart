import 'package:flutter/material.dart';

import '../Screens/login_page.dart';
import '../Screens/confession.dart';
import '../Screens/sign_up.dart';
import '../Screens/forgot_password.dart';

class RoutePath {
  static const String login = '/login';
  static const String confess = '/confess';
  static const String signup = '/signup';
  static const String forgot = '/forgot';

  static final routes = {
    login: (BuildContext context) => const Login(),
    confess: (BuildContext context) => const Confession(),
    signup: (BuildContext context) => const SignUp(),
    forgot: (BuildContext context) => const Forgot(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case RoutePath.confess:
        return MaterialPageRoute(builder: (_) => const Confession());
      case RoutePath.signup:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case RoutePath.forgot:
        return MaterialPageRoute(builder: (_) => const Forgot());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
