import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';
import '../../../core/providers/services_provider.dart';
import 'widgets/delete_account_dialog.dart';
import 'widgets/edit_username_dialog.dart';
import 'widgets/image_dialog.dart';

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

    Scaffold mainScaffold() {
      if (servicesProvider.userDetails == null) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Column(
              children: [
                GlobalVariables.spaceLarge(context),
                const Icon(
                  CarbonIcons.connection_signal,
                  size: 90,
                ),
                GlobalVariables.spaceMedium(),
                Text(
                  'Loading Profile Details',
                  textAlign: TextAlign.center,
                  style: WriteStyles.headerMedium(context)
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                GlobalVariables.spaceMedium(),
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),
        );
      }
      bool isGoogleAccount = servicesProvider.isUserSignedInWithGoogle();
      bool isUpload = servicesProvider.imageFile == null ? false : true;

      Widget profilePic() {
        if (servicesProvider.user?.photoURL != null &&
            servicesProvider.imageFile == null) {
          return Skeletonizer(
            enabled: servicesProvider.user!.photoURL!.isEmpty,
            child: CachedNetworkImage(
              key: UniqueKey(),
              placeholder: (context, url) {
                return Image.asset(
                  GlobalVariables.appIcon,
                  color: Theme.of(context).colorScheme.primary,
                );
              },
              imageUrl: servicesProvider.user!.photoURL as String,
              height: 150.h,
              width: 150.w,
              fit: BoxFit.cover,
            ),
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
          actions: [
            isUpload
                ? TextButton(
                    onPressed: () {
                      servicesProvider.imageFile = null;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Cancel',
                        style: WriteStyles.bodySmall(context).copyWith(
                            height: 3,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ))
                : const SizedBox(),
            isUpload
                ? TextButton(
                    onPressed: () async {
                      await servicesProvider.uploadImage();
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CarbonIcons.checkmark,
                            color: Theme.of(context).colorScheme.background,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            'Save',
                            style: WriteStyles.bodySmall(context).copyWith(
                                height: 3,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                        ],
                      ),
                    ))
                : const SizedBox(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    imageDialog(context, servicesProvider);
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: profilePic(),
                      ),
                      const Icon(
                        Icons.camera_alt,
                        size: 27,
                      )
                    ],
                  ),
                ),
                GlobalVariables.spaceSmall(),
                Text(
                  servicesProvider.user?.displayName ?? 'Pleibian',
                  style: WriteStyles.headerMedium(context),
                ),
                Text(
                  servicesProvider.userDetails!.email,
                  style: WriteStyles.headerSmall(context),
                ),
                GlobalVariables.spaceSmall(),
                GlobalVariables.spaceMedium(),
                ProfileInfo(
                  title: 'Username',
                  content: servicesProvider.user?.displayName ?? 'Pleibian',
                  icon: Icons.edit,
                  onTap: () {
                    editUsernameDialog(context, servicesProvider);
                  },
                ),
                GlobalVariables.spaceMedium(),
                ProfileInfo(
                  title: 'E-Mail',
                  content: servicesProvider.user?.email as String,
                ),
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
                IconButton(
                    onPressed: () async {
                      if (isGoogleAccount == true) {
                        await servicesProvider.googleDeleteUser(context);
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, 'onBoarding');
                      } else {
                        deleteAccountDialog(context, servicesProvider);
                      }
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

    return mainScaffold();
  }
}

// ignore: must_be_immutable
class ProfileInfo extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  void Function()? onTap;
  ProfileInfo(
      {super.key,
      required this.title,
      required this.content,
      this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: GlobalVariables.normPadding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: GlobalVariables.cardPadding,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).colorScheme.primary)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: WriteStyles.headerSmall(context).copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    content,
                    style: WriteStyles.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}
