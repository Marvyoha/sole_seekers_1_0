import 'package:flutter/material.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../constant/widgets/custom_button.dart';
import '../../constant/widgets/custom_textfield.dart';
import '../../core/providers/services_provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    var servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);

    Future<void> loginLogic() async {
      // Call signIn function from ServicesProvider
      servicesProvider.signIn(
          emailController.text, passwordController.text, context);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: GlobalVariables.normPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FOR CHANGING THEME

                SizedBox(height: 25.h),
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
                  'Kindly Login to access the app',
                  style: WriteStyles.bodyMedium(context),
                  textAlign: TextAlign.start,
                ),
                GlobalVariables.spaceMedium(),
                CustomTextField(
                    obscureText: false,
                    hintText: 'Email address',
                    controller: emailController),
                GlobalVariables.spaceMedium(),
                CustomTextField(
                    obscureText: true,
                    hintText: 'Password',
                    controller: passwordController),
                GlobalVariables.spaceMedium(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'forgotPassword');
                      },
                      child: Text(
                        'Forgot Password',
                        textAlign: TextAlign.end,
                        style: WriteStyles.hintText(context),
                      ),
                    ),
                  ],
                ),
                GlobalVariables.spaceMedium(),
                CustomButton(
                  text: 'Sign In',
                  isLoading:
                      Provider.of<ServicesProvider>(context, listen: true)
                          .loader,
                  onTap: loginLogic,
                ),
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
                GlobalVariables.spaceMedium(),

                Center(
                    child: IconButton(
                        onPressed: () => servicesProvider.googleSignIn(context),
                        icon: Icon(
                          CarbonIcons.logo_google,
                          size: 30.sp,
                        ))),
                GlobalVariables.spaceSmall(),
                Center(
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
                GlobalVariables.spaceSmall(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
