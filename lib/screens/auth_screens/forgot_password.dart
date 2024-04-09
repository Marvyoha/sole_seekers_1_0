import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../constant/widgets/custom_button.dart';
import '../../constant/widgets/custom_textfield.dart';
import '../../core/providers/services_provider.dart';
import 'widgets/privacy_policy_dialog.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    var servicesProvider = Provider.of<ServicesProvider>(context);

    Future<void> forgotPasswordLogic() async {
      // Call signIn function from ServicesProvider
      servicesProvider.resetPassword(emailController.text, context);
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
                      'Welcome SoleSeeker?',
                      style: WriteStyles.headerMedium(context),
                      textAlign: TextAlign.start,
                    ),
                    GlobalVariables.spaceSmaller(),
                    Text(
                      'Kindly enter your email to send a verification link.',
                      style: WriteStyles.bodyMedium(context),
                      textAlign: TextAlign.start,
                    ),
                    GlobalVariables.spaceMedium(),
                    CustomTextField(
                        hintText: 'Email address', controller: emailController),
                    SizedBox(height: 65.h),
                    CustomButton(
                        text: 'Reset Password',
                        onTap: forgotPasswordLogic,
                        isLoading:
                            Provider.of<ServicesProvider>(context, listen: true)
                                .loader),
                    GlobalVariables.spaceMedium(),
                    GestureDetector(
                      onTap: () => privacyPolicy(context),
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
            ],
          ),
        ),
      ),
    );
  }
}
