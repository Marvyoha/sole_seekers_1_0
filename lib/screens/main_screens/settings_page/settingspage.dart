import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

import '../../../constant/font_styles.dart';
import '../../../core/providers/services_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'More',
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
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    CarbonIcons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                GlobalVariables.spaceSmall(isWidth: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      servicesProvider.user?.displayName ?? 'Pleibian',
                      style: WriteStyles.headerMedium(context),
                    ),
                    Text(
                      servicesProvider.userDetails?.email as String,
                      style: WriteStyles.headerSmall(context),
                    )
                  ],
                )
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
              onTap: () {},
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
              onTap: () {},
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
