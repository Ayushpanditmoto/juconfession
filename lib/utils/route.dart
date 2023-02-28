import 'package:flutter/material.dart';

import '../Screens/login_page.dart';
import '../Screens/confession.dart';
import '../Screens/sign_up.dart';
import '../Screens/forgot_password.dart';
import '../Screens/single_post.dart';

class RoutePath {
  static const String login = '/login';
  static const String confess = '/confess';
  static const String signup = '/signup';
  static const String forgot = '/forgot';
  static const String singlePost = '/singlePost';

  static final routes = {
    login: (BuildContext context) => const Login(),
    confess: (BuildContext context) => const Confession(),
    signup: (BuildContext context) => const SignUp(),
    forgot: (BuildContext context) => const Forgot(),
    singlePost: (BuildContext context) => const SinglePost(),
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
      case RoutePath.singlePost:
        return MaterialPageRoute(builder: (_) => const SinglePost());
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
