import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/services_provider.dart';
import '../main_screens/homepage.dart';
import '../misc_screens/on_boarding.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: User,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const OnBoarding();
        }
      },
    );
  }
}
