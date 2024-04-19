import 'dart:io';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/screens/main_screens/settings_page/widgets/delete_account_dialog.dart';
import 'package:sole_seekers_1_0/screens/main_screens/settings_page/widgets/edit_username_dialog.dart';
import 'package:sole_seekers_1_0/screens/main_screens/settings_page/widgets/image_picker_dialog.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';
import '../../../core/providers/services_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    File? selectedImage;

    Future pickImageFromGallery() async {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage == null) return;

      setState(() {
        selectedImage = File(returnedImage.path);
      });
    }

    imagePickerDialog() {
      return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: selectedImage != null ? 400.h : 250.h,
            width: GlobalVariables.sizeWidth(context),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlobalVariables.spaceMedium(),
                selectedImage != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Image.file(selectedImage!))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0),
                        child: Text(
                          'Select an image from any source',
                          style: WriteStyles.headerMedium(context),
                        ),
                      ),
                GlobalVariables.spaceMedium(),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary)),
                    child: Text(
                      'Upload from Camera',
                      style: WriteStyles.bodySmall(context).copyWith(
                          height: 5,
                          color: Theme.of(context).colorScheme.background),
                    )),
                GlobalVariables.spaceSmall(),
                ElevatedButton(
                    onPressed: () => pickImageFromGallery(),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary)),
                    child: Text(
                      'Upload from Gallery',
                      style: WriteStyles.bodySmall(context).copyWith(
                          height: 5,
                          color: Theme.of(context).colorScheme.background),
                    ))
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  CarbonIcons.person,
                  size: 50,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              GlobalVariables.spaceSmall(),
              Text(
                servicesProvider.user?.displayName ?? 'Pleibian',
                style: WriteStyles.headerMedium(context),
              ),
              Text(
                servicesProvider.userDetails?.email as String,
                style: WriteStyles.headerSmall(context),
              ),
              GlobalVariables.spaceMedium(),
              ProfileTile(
                  icon: CarbonIcons.user_avatar,
                  onTap: () {
                    imagePickerDialog();
                  },
                  text: 'Edit Profile Picture'),
              GlobalVariables.spaceSmall(),
              ProfileTile(
                  icon: CarbonIcons.user_data,
                  onTap: () {
                    editUsernameDialog(context, servicesProvider);
                  },
                  text: 'Edit User name'),
              GlobalVariables.spaceMedium(),
              IconButton(
                  onPressed: () {
                    servicesProvider.signOut(context);
                  },
                  icon: SizedBox(
                    height: 30.h,
                    width: 100.w,
                    child: Row(
                      children: [
                        Text(
                          'Sign Out',
                          style: WriteStyles.headerSmall(context)
                              .copyWith(color: Colors.red),
                        ),
                        GlobalVariables.spaceSmaller(isWidth: true),
                        const Icon(CarbonIcons.login)
                      ],
                    ),
                  )),
              GlobalVariables.spaceSmall(),
              IconButton(
                  onPressed: () {
                    deleteAccountDialog(context, servicesProvider);
                  },
                  icon: SizedBox(
                    height: 30.h,
                    width: 160.w,
                    child: Row(
                      children: [
                        Text(
                          'Delete Account',
                          style: WriteStyles.headerSmall(context)
                              .copyWith(color: Colors.red),
                        ),
                        GlobalVariables.spaceSmaller(isWidth: true),
                        const Icon(
                          CarbonIcons.delete,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData? icon;
  final void Function()? onTap;
  final String text;
  const ProfileTile(
      {super.key, required this.icon, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 30,
                    ),
                    GlobalVariables.spaceMedium(isWidth: true),
                    Text(
                      text,
                      style: WriteStyles.headerSmall(context),
                    )
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
