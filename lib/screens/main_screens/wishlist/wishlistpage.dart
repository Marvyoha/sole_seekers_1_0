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
    servicesProvider.getCurrentUserDoc();
    servicesProvider.getCatalogs();

    List<Map> wishlistArray = servicesProvider.getWishlist();
    bool checkFavorites() {
      if (servicesProvider.currentUserDoc?['wishlist'].isEmpty) {
        return true;
      } else {
        return false;
      }
    }

    bool isFilled = checkFavorites();
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
        body: isFilled
            ? Center(
                child: Column(
                  children: [
                    GlobalVariables.spaceLarge(context),
                    const Icon(
                      CarbonIcons.star_review,
                      size: 90,
                    ),
                    Text(
                      'No Wishlisted Shoes... ',
                      style: WriteStyles.headerMedium(context)
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: wishlistArray.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = wishlistArray[index];
                    final id = item['id'];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProductDetailsPage(
                                    item: item,
                                    id: id,
                                  ))),
                      child: Container(
                        padding: GlobalVariables.normPadding,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Hero(
                                    tag: 'CatalogItem $id',
                                    child: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl: item['image'],
                                      height: 90.h,
                                      width: 90.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GlobalVariables.spaceSmall(isWidth: true),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      overflow: TextOverflow.clip,
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
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    servicesProvider.removeFromWishlist(
                                        id: item['id']);
                                    setState(
                                        () {}); // Add this line to trigger a rebuild of the entire page
                                  },
                                  icon: const Icon(
                                    CarbonIcons.star_filled,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
