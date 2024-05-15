import 'package:flutter/material.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/widgets/custom_button.dart';
import '../../../../constant/widgets/custom_textfield.dart';
import '../../../../core/providers/services_provider.dart';

deleteAccountDialog(BuildContext context, ServicesProvider provider) {
  TextEditingController passwordController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text("Are you sure want to delete your account?",
              style: WriteStyles.headerMedium(context)
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
          content: CustomTextField(
              obscureText: true,
              hintText: 'Enter Password',
              controller: passwordController),
          actions: [
            CustomButton(
                text: 'Delete Account',
                isLoading: provider.loader,
                onTap: () async {
                  await provider.deleteUser(context, passwordController.text);
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, 'onBoarding');
                }),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: WriteStyles.bodySmall(context)
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ))
          ],
        );
      });
}
