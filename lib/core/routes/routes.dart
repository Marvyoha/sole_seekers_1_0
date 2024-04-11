import 'package:flutter/material.dart';

import '../../screens/auth_screens/auth_checker.dart';
import '../../screens/auth_screens/forgot_password.dart';
import '../../screens/auth_screens/login.dart';
import '../../screens/auth_screens/signup.dart';
import '../../screens/main_screens/homepage/homepage.dart';
import '../../screens/misc_screens/main_navigation.dart';
import '../../screens/main_screens/homepage/widgets/searchpage.dart';
import '../../screens/misc_screens/on_boarding.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(builder: (_) => const Login());
      case 'signup':
        return MaterialPageRoute(builder: (_) => const SignUp());
      case 'authChecker':
        return MaterialPageRoute(builder: (_) => const AuthChecker());
      case 'homePage':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'onBoarding':
        return MaterialPageRoute(builder: (_) => const OnBoarding());
      case 'forgotPassword':
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case 'searchPage':
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case 'mainNav':
        return MaterialPageRoute(builder: (_) => const MainNav());
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
      builder: (_) => const Scaffold(
            body: Center(child: Text('No Routes Found')),
          ));
}
