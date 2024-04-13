import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.getCurrentUserDoc();
    final qp = Provider.of<QueryProvider>(context, listen: true);

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
                                                color: const Color(0xff2A7351)),
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
