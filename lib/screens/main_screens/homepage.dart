import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../core/models/shoes_model.dart';
import '../../core/providers/services_provider.dart';
import '../../core/providers/theme_provider.dart';
import 'widgets/brand_button.dart';
import 'widgets/searchpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool nike = false,
    adidas = false,
    reebok = false,
    nakedWolfe = false,
    newBalance = false;

String checkSelectedBrand() {
  if (nike) return 'nike';
  if (adidas) return 'adidas';
  if (reebok) return 'reebok';
  if (nakedWolfe) return 'nakedWolfe';
  if (newBalance) return 'newBalance';
  return 'allItems';
}

Query<Item> querySetter() {
  String selected = checkSelectedBrand();
  Query<Item> newQuery;

  switch (selected) {
    case 'nike':
      newQuery = ServicesProvider().shoesPGDb.where("brand", isEqualTo: 'nike');
    case 'adidas':
      newQuery =
          ServicesProvider().shoesPGDb.where("brand", isEqualTo: 'adidas');
    case 'reebok':
      newQuery =
          ServicesProvider().shoesPGDb.where("brand", isEqualTo: 'reebok');
    case 'nakedWolfe':
      newQuery =
          ServicesProvider().shoesPGDb.where("brand", isEqualTo: 'nakedWolfe');
    case 'newBalance':
      newQuery =
          ServicesProvider().shoesPGDb.where("brand", isEqualTo: 'newBalance');
    default:
      newQuery = ServicesProvider().shoesPGDb.orderBy('id');
  }

  return newQuery;
}

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
                GlobalVariables.spaceSmall(),
                //CATEGORY PICKER
                const BrandList(),
                // ITEMS
                FirestoreQueryBuilder(
                    query: querySetter(),
                    builder: (context, snapshot, _) {
                      if (snapshot.isFetching) {
                        return Column(
                          children: [
                            GlobalVariables.spaceLarge(context),
                            const CircularProgressIndicator(),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        debugPrint('Pagination Error: ${snapshot.error}');
                        return Text('Pagination Error: ${snapshot.error}');
                      }
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6),
                          itemCount: snapshot.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            // if we reached the end of the currently obtained items, we try to
                            // obtain more items
                            if (snapshot.hasMore &&
                                index + 1 == snapshot.docs.length) {
                              // Telling FirestoreQueryBuilder to try to obtain more items.
                              // It is safe to call this function from within the build method.
                              snapshot.fetchMore();
                            }
                            final item = snapshot.docs[index];
                            return Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(item['image'])),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      item['id'].toString(),
                                      style: WriteStyles.cardSubtitle(context)
                                          .copyWith(),
                                    ),
                                    Text(
                                      item['name'],
                                      style: WriteStyles.cardSubtitle(context)
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    })
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
      child: Wrap(
        children: [
          BrandButton(
              onTap: () {
                setState(() {
                  nike = !nike;
                  adidas = false;
                  reebok = false;
                  nakedWolfe = false;
                  newBalance = false;
                });
                Navigator.pushReplacementNamed(context, 'mainNav');
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
                  newBalance = false;
                });
                Navigator.pushReplacementNamed(context, 'mainNav');
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
                  newBalance = false;
                });
                Navigator.pushReplacementNamed(context, 'mainNav');
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
                  newBalance = false;
                });
                Navigator.pushReplacementNamed(context, 'mainNav');
              },
              clickedBool: nakedWolfe,
              image: GlobalVariables.brandLogo4),
          BrandButton(
              onTap: () {
                setState(() {
                  nike = false;
                  adidas = false;
                  reebok = false;
                  nakedWolfe = false;
                  newBalance = !newBalance;
                });
                Navigator.pushReplacementNamed(context, 'mainNav');
              },
              clickedBool: newBalance,
              image: GlobalVariables.brandLogo5),
        ],
      ),
    );
  }
}
