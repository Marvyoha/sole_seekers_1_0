import 'package:flutter/material.dart';

import '../../screens/auth_screens/auth_checker.dart';
import '../../screens/auth_screens/forgot_password.dart';
import '../../screens/auth_screens/login.dart';
import '../../screens/auth_screens/signup.dart';
import '../../screens/main_screens/homepage.dart';
import '../../screens/main_screens/widgets/searchpage.dart';
import '../../screens/misc_screens/on_boarding.dart';
import '../../screens/misc_screens/splashscreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
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
