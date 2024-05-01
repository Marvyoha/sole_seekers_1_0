import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../constant/widgets/custom_button.dart';
import '../../constant/widgets/custom_textfield.dart';
import '../../core/providers/services_provider.dart';

class GoogleSignup extends StatelessWidget {
  const GoogleSignup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();

    var servicesProvider = Provider.of<ServicesProvider>(context);

    Future<void> googleSigninLogic() async {
      try {
        servicesProvider.loader = true;
        servicesProvider.storeUserDetails(username: userNameController.text);
        servicesProvider.loader = false;

        servicesProvider.auth?.authStateChanges().listen((user) {
          if (user != null) {
            // Navigate to home
            Navigator.pushReplacementNamed(
              context,
              'mainNav',
            );
          }
        });
      } on FirebaseAuthException catch (e) {
        debugPrint('Google Auth Error: [${e.code}]' ' ${e.message}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                e.message!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: GlobalVariables.normPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalVariables.spaceSmall(),
                Center(
                  child: Image.asset(
                    GlobalVariables.logo,
                    width: 213.w,
                    height: 171.h,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Welcome SoleSeeker!',
                  style: WriteStyles.headerMedium(context),
                  textAlign: TextAlign.start,
                ),
                GlobalVariables.spaceSmaller(),
                Text(
                  'Kindly enter a user name.',
                  style: WriteStyles.bodyMedium(context),
                  textAlign: TextAlign.start,
                ),
                GlobalVariables.spaceMedium(),
                CustomTextField(
                    hintText: 'User name', controller: userNameController),
                SizedBox(height: 65.h),
                CustomButton(
                    text: 'Confirm',
                    onTap: googleSigninLogic,
                    isLoading:
                        Provider.of<ServicesProvider>(context, listen: true)
                            .loader),
                GlobalVariables.spaceMedium(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'privacyPolicy'),
                  child: Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text:
                              'By pressing “Sign In”, you accept the \nconditions of  ',
                          style: WriteStyles.bodySmall(context)),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: WriteStyles.bodySmall(context).copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ])),
                  ),
                ),
                SizedBox(height: 101.h),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Don\'t have an account? ',
                          style: WriteStyles.bodySmall(context)),
                      TextSpan(
                        text: 'Sign Up',
                        style: WriteStyles.bodySmall(context).copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
