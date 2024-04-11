import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../misc_screens/main_navigation.dart';
import '../misc_screens/on_boarding.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: User,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const MainNav();
        } else {
          return const OnBoarding();
        }
      },
    );
  }
}
