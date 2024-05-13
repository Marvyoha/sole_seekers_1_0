import 'package:flutter/material.dart';
import 'package:sole_seekers_1_0/main.dart';

import '../../constant/widgets/about_app.dart';
import '../../constant/widgets/privacyPolicy.dart';
import '../../constant/widgets/termsAndConditions.dart';
import '../../screens/auth_screens/auth_checker.dart';
import '../../screens/auth_screens/forgot_password.dart';
import '../../screens/auth_screens/google_signup.dart';
import '../../screens/auth_screens/login.dart';
import '../../screens/auth_screens/signup.dart';
import '../../screens/main_screens/cartpage/checkout_screens/confirmation_page.dart';
import '../../screens/main_screens/cartpage/checkout_screens/personal_details.dart';
import '../../screens/main_screens/homepage/homepage.dart';
import '../../screens/main_screens/settings_page/profile.dart';
import '../../screens/main_screens/settings_page/purchase_history_page.dart';
import '../../screens/misc_screens/main_navigation.dart';
import '../../screens/main_screens/homepage/widgets/searchpage.dart';
import '../../screens/misc_screens/on_boarding.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'mainApp':
        return MaterialPageRoute(builder: (_) => const MainApp());
      case 'login':
        return MaterialPageRoute(builder: (_) => const Login());
      case 'signup':
        return MaterialPageRoute(builder: (_) => const SignUp());
      case 'googleSignup':
        return MaterialPageRoute(builder: (_) => const GoogleSignup());
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
      case 'profilePage':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case 'purchaseHistoryPage':
        return MaterialPageRoute(builder: (_) => const PurchaseHistoryPage());
      case 'personalDetails':
        return MaterialPageRoute(builder: (_) => const PersonalDetails());
      case 'confirmationPage':
        return MaterialPageRoute(builder: (_) => const ConfirmationPage());
      case 'privacyPolicy':
        return MaterialPageRoute(builder: (_) => const PrivacyPolicy());
      case 'termsAndConditions':
        return MaterialPageRoute(builder: (_) => const TermsAndConditions());
      case 'aboutApp':
        return MaterialPageRoute(builder: (_) => const AboutApp());
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
