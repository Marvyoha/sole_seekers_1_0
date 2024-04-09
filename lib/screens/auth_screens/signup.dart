import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../constant/widgets/custom_button.dart';
import '../../constant/widgets/custom_textfield.dart';
import '../../core/providers/services_provider.dart';
import '../../constant/widgets/privacy_policy_dialog.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    var servicesProvider = Provider.of<ServicesProvider>(context);

    Future<void> signupLogic() async {
      // Call signUp function from ServicesProvider
      servicesProvider.signUp(emailController.text, passwordController.text,
          confirmPasswordController.text, userNameController.text, context);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 35.sp,
                ),
              ),
              Padding(
                padding: GlobalVariables.normPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      'Kindly Signup to access the app',
                      style: WriteStyles.bodyMedium(context),
                      textAlign: TextAlign.start,
                    ),
                    GlobalVariables.spaceMedium(),
                    CustomTextField(
                        hintText: 'User name', controller: userNameController),
                    GlobalVariables.spaceSmaller(),
                    CustomTextField(
                        obscureText: false,
                        hintText: 'Email address',
                        controller: emailController),
                    GlobalVariables.spaceSmaller(),
                    CustomTextField(
                        obscureText: true,
                        hintText: 'Password',
                        controller: passwordController),
                    GlobalVariables.spaceSmaller(),
                    CustomTextField(
                        obscureText: true,
                        hintText: 'Confirm Password',
                        controller: confirmPasswordController),
                    GlobalVariables.spaceMedium(),
                    CustomButton(
                      text: 'Sign Up',
                      onTap: signupLogic,
                      isLoading:
                          Provider.of<ServicesProvider>(context, listen: true)
                              .loader,
                    ),
                    GlobalVariables.spaceMedium(),
                    GestureDetector(
                      onTap: () => privacyPolicy(context),
                      child: Center(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text:
                                  'By pressing “Sign Up”, you accept the \nconditions of  ',
                              style: WriteStyles.bodySmall(context)),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: WriteStyles.bodySmall(context).copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ])),
                      ),
                    ),
                    GlobalVariables.spaceMedium(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
