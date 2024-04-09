import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../core/providers/services_provider.dart';
import 'widgets/brand_button.dart';
import 'widgets/searchpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool nike = false, adidas = false, reebok = false, nakedWolfe = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.getCurrentUserDoc();

    return Scaffold(
      body: Container(
        height: GlobalVariables.sizeHeight(context),
        width: GlobalVariables.sizeWidth(context),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Container(
            padding: GlobalVariables.normPadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome ${servicesProvider.user?.displayName}',
                      style: WriteStyles.headerMedium(context).copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          CarbonIcons.person,
                          size: 30,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    )
                  ],
                ),
                GlobalVariables.spaceMedium(),

                //SEARCH BUTTON
                GestureDetector(
                    onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return const SearchPage();
                        }),
                    child: Material(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 55,
                        padding: GlobalVariables.normPadding,
                        child: Row(
                          children: [
                            Icon(
                              CarbonIcons.search,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            GlobalVariables.spaceSmaller(isWidth: true),
                            Text(
                              'Search for Shoes Here....',
                              style: WriteStyles.bodySmall(context),
                            )
                          ],
                        ),
                      ),
                    )),
                GlobalVariables.spaceMedium(),
                const BrandList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrandList extends StatefulWidget {
  const BrandList({super.key});

  @override
  State<BrandList> createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          BrandButton(
              onTap: () {
                setState(() {
                  nike = !nike;
                  adidas = false;
                  reebok = false;
                  nakedWolfe = false;
                });
              },
              clickedBool: nike,
              image: GlobalVariables.brandLogo1),
          BrandButton(
              onTap: () {
                setState(() {
                  nike = false;
                  adidas = !adidas;
                  reebok = false;
                  nakedWolfe = false;
                });
              },
              clickedBool: adidas,
              image: GlobalVariables.brandLogo2),
          BrandButton(
              onTap: () {
                setState(() {
                  nike = false;
                  adidas = false;
                  reebok = !reebok;
                  nakedWolfe = false;
                });
              },
              clickedBool: reebok,
              image: GlobalVariables.brandLogo3),
          BrandButton(
              onTap: () {
                setState(() {
                  nike = false;
                  adidas = false;
                  reebok = false;
                  nakedWolfe = !nakedWolfe;
                });
              },
              clickedBool: nakedWolfe,
              image: GlobalVariables.brandLogo4),
        ],
      ),
    );
  }
}
