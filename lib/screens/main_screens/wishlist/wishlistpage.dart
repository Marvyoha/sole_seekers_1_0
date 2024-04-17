import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';
import '../../../core/models/shoes_model.dart';
import '../../../core/providers/query_provider.dart';
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
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    // servicesProvider.getCurrentUserDoc();
    // servicesProvider.getCatalogs();

    List<Map> wishlistArray = servicesProvider.getWishlist();
    bool isWishlisted() {
      if (servicesProvider.userDetails!.wishlist.isEmpty) {
        return true;
      } else {
        return false;
      }
    }

    bool isEmpty = isWishlisted();
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
      body: isEmpty
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
                                          GlobalVariables.appIcon);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: WriteStyles.bodySmall(context)
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            servicesProvider.removeFromWishlist(
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
            ),
    );
  }
}
