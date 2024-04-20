import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/screens/main_screens/settings_page/widgets/delete_account_dialog.dart';
import 'package:sole_seekers_1_0/screens/main_screens/settings_page/widgets/edit_username_dialog.dart';

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
    bool isUpload = servicesProvider.imageFile == null ? false : true;

    Widget profilePic() {
      if (servicesProvider.userDetails!.profilePicture.isNotEmpty &&
          servicesProvider.imageFile == null) {
        return CachedNetworkImage(
          key: UniqueKey(),
          placeholder: (context, url) {
            return Image.asset(
              GlobalVariables.appIcon,
              color: Theme.of(context).colorScheme.primary,
            );
          },
          imageUrl: servicesProvider.userDetails!.profilePicture,
          height: 150.h,
          width: 150.w,
          fit: BoxFit.cover,
        );
      } else if (servicesProvider.imageFile != null) {
        return Image.file(
          height: 150.h,
          width: 150.w,
          servicesProvider.imageFile!,
          fit: BoxFit.cover,
        );
      }
      return CircleAvatar(
        radius: 80,
        child: Icon(
          CarbonIcons.user_avatar_filled,
          size: 100,
          color: Theme.of(context).colorScheme.background,
        ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: profilePic(),
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
              GlobalVariables.spaceSmall(),
              TextButton(
                  onPressed: () =>
                      servicesProvider.pickImage(ImageSource.camera),
                  child: Container(
                    width: 190.w,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CarbonIcons.camera),
                        SizedBox(width: 5.w),
                        Text(
                          'Upload from Camera',
                          style: WriteStyles.bodySmall(context).copyWith(
                              height: 3,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  )),
              TextButton(
                  onPressed: () =>
                      servicesProvider.pickImage(ImageSource.gallery),
                  child: Container(
                    width: 190.w,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CarbonIcons.image),
                        SizedBox(width: 5.w),
                        Text(
                          'Upload from Gallery',
                          style: WriteStyles.bodySmall(context).copyWith(
                              height: 3,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  )),
              isUpload
                  ? TextButton(
                      onPressed: () => servicesProvider.uploadImage(),
                      child: Container(
                        width: 190.w,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CarbonIcons.cloud,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              'Update Profile Picture',
                              style: WriteStyles.bodySmall(context).copyWith(
                                  height: 3,
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                          ],
                        ),
                      ))
                  : const SizedBox(),
              isUpload == true
                  ? TextButton(
                      onPressed: () {
                        servicesProvider.imageFile = null;
                        setState(() {});
                      },
                      child: Container(
                        width: 190.w,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CarbonIcons.image),
                            SizedBox(width: 5.w),
                            Text(
                              'Cancel',
                              style: WriteStyles.bodySmall(context).copyWith(
                                  height: 3,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ))
                  : const SizedBox(),
              GlobalVariables.spaceMedium(),
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
