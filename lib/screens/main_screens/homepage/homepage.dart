import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';

import '../../../core/providers/query_provider.dart';
import '../../../core/providers/services_provider.dart';
import '../../misc_screens/product_details_page.dart';
import 'widgets/brand_selection.dart';
import 'widgets/searchpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool isLoading = true;
  // Future loadData() async {
  //   ServicesProvider();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   loadData().then((_) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);

    final qp = Provider.of<QueryProvider>(context, listen: true);
    bool isProfile = servicesProvider.user?.photoURL?.isEmpty ?? true;

    Widget profilePic() {
      if (isProfile) {
        return CircleAvatar(
          child: Icon(
            CarbonIcons.user_avatar_filled,
            size: 30,
            color: Theme.of(context).colorScheme.background,
          ),
        );
      }
      return Skeletonizer(
          enabled: isProfile,
          child: CachedNetworkImage(
            key: UniqueKey(),
            placeholder: (context, url) {
              return Image.asset(
                GlobalVariables.appIcon,
                color: Theme.of(context).colorScheme.primary,
              );
            },
            imageUrl: servicesProvider.user?.photoURL as String,
            height: 45.h,
            width: 45.w,
            fit: BoxFit.cover,
          ));
    }

    // Future loadEssentials() async {
    //   try {
    //     await servicesProvider.getCurrentUserDoc();
    //     return 1;
    //   } catch (e) {
    //     return 0;
    //   }
    // }

    // FutureBuilder(
    //                         future: loadEssentials(),
    //                         builder:
    //                             (BuildContext context, AsyncSnapshot snapshot) {
    //                           if (snapshot.hasData) {
    //                             if (servicesProvider
    //                                 .userDetails!.profilePicture.isNotEmpty) {
    //                               return CachedNetworkImage(
    //                                 key: UniqueKey(),
    //                                 placeholder: (context, url) {
    //                                   return Image.asset(
    //                                     GlobalVariables.appIcon,
    //                                     color: Theme.of(context)
    //                                         .colorScheme
    //                                         .primary,
    //                                   );
    //                                 },
    //                                 imageUrl: servicesProvider
    //                                     .userDetails!.profilePicture,
    //                                 height: 45.h,
    //                                 width: 45.w,
    //                                 fit: BoxFit.cover,
    //                               );
    //                             }
    //                           }
    //                           return CircleAvatar(
    //                             // radius: 24.6,
    //                             child: Icon(
    //                               CarbonIcons.user_avatar_filled,
    //                               size: 30,
    //                               color:
    //                                   Theme.of(context).colorScheme.background,
    //                             ),
    //                           );
    //                         },
    //                       ),

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
                      'Welcome ${servicesProvider.user?.displayName ?? 'Pleibian'}',
                      style: WriteStyles.headerMedium(context).copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, 'profilePage'),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: SizedBox(
                            height: 45.h, width: 45.w, child: profilePic()),
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
                    query: qp.newQuery,
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
                                  crossAxisCount: 2, mainAxisExtent: 250),
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
                            final id = item['id'];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProductDetailsPage(
                                            item: item,
                                            id: id,
                                          ))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 7),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Hero(
                                          tag: 'CatalogItem $id',
                                          child: CachedNetworkImage(
                                            key: UniqueKey(),
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                GlobalVariables.appIcon,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              );
                                            },
                                            imageUrl: item['image'],
                                            height: 150.h,
                                            width: 150.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      GlobalVariables.spaceSmall(),
                                      Text(
                                        item['name'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: WriteStyles.bodySmall(context)
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        ' \$${item['price'].toString()}',
                                        style: WriteStyles.bodySmall(context)
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary),
                                      ),
                                    ],
                                  ),
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
