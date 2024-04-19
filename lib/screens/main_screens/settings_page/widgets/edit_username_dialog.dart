import 'package:flutter/material.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/widgets/custom_button.dart';
import '../../../../constant/widgets/custom_textfield.dart';
import '../../../../core/providers/services_provider.dart';

editUsernameDialog(BuildContext context, ServicesProvider provider) {
  TextEditingController usernameController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text("Enter a New User name",
              style: WriteStyles.headerMedium(context)
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
          content:
              CustomTextField(hintText: '', controller: usernameController),
          actions: [
            CustomButton(
                text: 'Change User name',
                isLoading: provider.loader,
                onTap: () {
                  provider.updateUserName(username: usernameController.text);
                  Navigator.pop(context);
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
