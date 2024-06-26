// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/core/providers/services_provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../main_screens/cartpage/cartpage.dart';
import '../main_screens/homepage/homepage.dart';
import '../main_screens/settings_page/settingspage.dart';
import '../main_screens/wishlist/wishlistpage.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

final List<Widget> pages = [
  const HomePage(),
  const CartPage(),
  const WishListPage(),
  const SettingsPage()
];
int currentIndex = 0;

class _MainNavState extends State<MainNav> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isDialogSet = false;

  @override
  void initState() {
    getConnectivity();

    super.initState();
  }

  getConnectivity() => subscription =
          Connectivity().onConnectivityChanged.listen((result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isDialogSet == false) {
          showDialogBox();
          setState(() => isDialogSet = true);
        }
      });

  showDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              "Lost Internet Connection",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            content: SizedBox(
              height: 145.h,
              child: Column(
                children: [
                  const Icon(
                    CarbonIcons.data_error,
                    color: Colors.red,
                    size: 90,
                  ),
                  Text(
                    'No Internet Connection,\n Try again or exit the app.',
                    textAlign: TextAlign.center,
                    style: WriteStyles.bodyMedium(context)
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      isDialogSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();
                      setState(() => isDialogSet = true);
                    }
                  },
                  child: Text(
                    'Reconnect',
                    style: WriteStyles.bodyMedium(context)
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  )),
              TextButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    'Exit app',
                    style: WriteStyles.bodyMedium(context)
                        .copyWith(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    currentIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    nullSafetyChecker() {
      switch (currentIndex) {
        case 1:
          if (servicesProvider.userDetails == null ||
              servicesProvider.catalogs == null) {
            return Center(
              child: Column(
                children: [
                  GlobalVariables.spaceLarge(context),
                  const Icon(
                    CarbonIcons.connection_signal,
                    size: 90,
                  ),
                  GlobalVariables.spaceMedium(),
                  Text(
                    'Loading Shopping Cart..',
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
            );
          } else {
            return const CartPage();
          }
        case 2:
          if (servicesProvider.userDetails == null ||
              servicesProvider.catalogs == null) {
            return Center(
              child: Column(
                children: [
                  GlobalVariables.spaceLarge(context),
                  const Icon(
                    CarbonIcons.connection_signal,
                    size: 90,
                  ),
                  GlobalVariables.spaceMedium(),
                  Text(
                    'Loading Wishlist..',
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
            );
          } else {
            return const WishListPage();
          }

        default:
          return pages[currentIndex];
      }
    }

    return Scaffold(
      body: nullSafetyChecker(),
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
            CarbonIcons.shopping_cart,
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
            Icons.more_horiz,
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
