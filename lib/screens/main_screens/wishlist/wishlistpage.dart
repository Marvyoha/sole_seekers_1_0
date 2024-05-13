import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';
import '../../../core/providers/services_provider.dart';
import '../../misc_screens/product_details_page.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    Widget mainBody() {
      return Consumer<ServicesProvider>(
        builder: (context, servicesProvider, child) {
          if (servicesProvider.userDetails == null) {
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
          }
          List<Map> wishlistArray = servicesProvider.getWishlist();
          bool isEmpty = servicesProvider.userDetails!.wishlist.isEmpty;
          return isEmpty
              ? Center(
                  child: Column(
                    children: [
                      GlobalVariables.spaceLarge(context),
                      GlobalVariables.spaceLarge(context),
                      const Icon(
                        CarbonIcons.star_review,
                        size: 90,
                      ),
                      GlobalVariables.spaceMedium(),
                      Text(
                        'No Wishlisted Shoes... ',
                        style: WriteStyles.headerMedium(context)
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: wishlistArray.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = wishlistArray[index];
                    final id = item['id'];
                    return Column(
                      children: [
                        Padding(
                          padding: GlobalVariables.normPadding,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsPage(
                                  item: item,
                                  id: id,
                                ),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
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
                                        height: 90.h,
                                        width: 90.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GlobalVariables.spaceSmall(isWidth: true),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: WriteStyles.bodySmall(context)
                                              .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ' \$${item['price'].toString()}',
                                              style:
                                                  WriteStyles.bodySmall(context)
                                                      .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                servicesProvider
                                                    .removeFromWishlist(
                                                  id: item['id'],
                                                );
                                              },
                                              icon: const Icon(
                                                CarbonIcons.star_filled,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GlobalVariables.spaceSmall(),
                      ],
                    );
                  },
                );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Wish List',
            style: WriteStyles.headerMedium(context)
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: mainBody());
  }
}
