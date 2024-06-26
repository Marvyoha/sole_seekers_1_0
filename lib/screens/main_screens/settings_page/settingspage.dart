import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

import '../../../constant/font_styles.dart';
import '../../../core/providers/services_provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    Widget profilePic() {
      if (servicesProvider.user?.photoURL != null) {
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
            height: 80.h,
            width: 80.w,
            fit: BoxFit.cover,
          ),
        );
      }
      return CircleAvatar(
        radius: 40,
        child: Icon(
          CarbonIcons.user_avatar_filled,
          size: 50,
          color: Theme.of(context).colorScheme.background,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: const SizedBox(),
        title: Text(
          '',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: profilePic(),
                ),
                GlobalVariables.spaceSmall(isWidth: true),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicesProvider.user?.displayName ?? 'Pleibian',
                        style: WriteStyles.headerMedium(context),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      Text(
                        servicesProvider.user!.email as String,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: WriteStyles.headerSmall(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GlobalVariables.spaceSmall(),
            Row(
              children: [
                Text(
                  'General',
                  textAlign: TextAlign.left,
                  style: WriteStyles.headerSmall(context),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            GlobalVariables.spaceSmall(),
            MoreTile(
              icon: CarbonIcons.user_profile,
              onTap: () => Navigator.pushNamed(context, 'profilePage'),
              text: 'Profile',
            ),
            MoreTile(
              icon: CarbonIcons.contrast,
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(context);
              },
              text: 'Change Theme',
            ),
            GlobalVariables.spaceSmall(),
            Row(
              children: [
                Text(
                  'Misc',
                  textAlign: TextAlign.left,
                  style: WriteStyles.headerSmall(context),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            MoreTile(
              icon: CarbonIcons.money,
              onTap: () => Navigator.pushNamed(context, 'purchaseHistoryPage'),
              text: 'Purchase History',
            ),
            MoreTile(
              icon: CarbonIcons.policy,
              onTap: () => Navigator.pushNamed(context, 'privacyPolicy'),
              text: 'Privacy Policy',
            ),
            MoreTile(
              icon: CarbonIcons.websheet,
              onTap: () => Navigator.pushNamed(context, 'termsAndConditions'),
              text: 'Terms and Conditions',
            ),
            MoreTile(
              icon: CarbonIcons.book,
              onTap: () => Navigator.pushNamed(context, 'aboutApp'),
              text: 'About App',
            ),
          ],
        ),
      ),
    );
  }
}

class MoreTile extends StatelessWidget {
  final IconData? icon;
  final void Function()? onTap;
  final String text;
  const MoreTile(
      {super.key, required this.icon, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(40),
          //     border: Border.all(color: Theme.of(context).colorScheme.primary)),
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
    );
  }
}
