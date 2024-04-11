import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main_screens/checkout/checkoutpage.dart';
import '../main_screens/homepage/homepage.dart';
import '../main_screens/settings_page/settingspage.dart';
import '../main_screens/wishlist/wishlistpage.dart';

class MainNav extends StatefulWidget {
  final int? index;
  const MainNav({this.index, super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

final List<Widget> pages = [
  const HomePage(),
  const CheckoutPage(),
  const WishListPage(),
  const SettingsPage()
];
int currentIndex = 0;

class _MainNavState extends State<MainNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60.h,
        index: currentIndex,
        animationDuration: const Duration(milliseconds: 400),
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(
            CarbonIcons.home,
            size: 30,
            color: currentIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
          Icon(
            CarbonIcons.money,
            size: 30,
            color: currentIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
          Icon(
            CarbonIcons.star,
            size: 30,
            color: currentIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
          Icon(
            CarbonIcons.settings,
            size: 30,
            color: currentIndex == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
