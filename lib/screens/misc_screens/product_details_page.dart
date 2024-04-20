// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/constant/font_styles.dart';

import '../../constant/global_variables.dart';
import '../../core/models/user_info.dart';
import '../../core/providers/services_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final int id;
  final dynamic item;

  const ProductDetailsPage({
    super.key,
    required this.id,
    required this.item,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1, total = 0;

  @override
  void initState() {
    total = widget.item['price'];

    super.initState();
  }

  int quantityHandler() {
    if (quantity < 1) {
      quantity = 1;
    }
    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    bool wishListChecker() {
      bool checker;
      List wishlist = servicesProvider.userDetails!.wishlist;
      if (wishlist.contains(widget.item['id'])) {
        checker = true;
      } else {
        checker = false;
      }

      return checker;
    }

    bool cartChecker() {
      List cart = servicesProvider.userDetails!.cart;
      for (Cart element in cart) {
        if (element.id == widget.item['id']) {
          return true;
        }
      }
      return false;
    }

    bool isWishlist = wishListChecker();
    bool isCart = cartChecker();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: GlobalVariables.normPadding,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Hero(
                        tag: 'CatalogItem ${widget.id}',
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          placeholder: (context, url) {
                            return Image.asset(GlobalVariables.appIcon);
                          },
                          imageUrl: widget.item['image'],
                          width: 343.w,
                          height: 286.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // WISH LIST BUTTON
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 20),
                      child: IconButton(
                          onPressed: () {
                            isWishlist == false
                                ? servicesProvider.addToWishlist(id: widget.id)
                                : servicesProvider.removeFromWishlist(
                                    id: widget.id);

                            setState(() {
                              isWishlist = !isWishlist;
                            });
                          },
                          icon: Icon(
                            isWishlist
                                ? CarbonIcons.star_filled
                                : CarbonIcons.star,
                            size: 40,
                            color: Theme.of(context).colorScheme.surface,
                          )),
                    )
                  ],
                ),
                GlobalVariables.spaceMedium(),
                Text(
                  widget.item['name'],
                  style: WriteStyles.headerMedium(context),
                ),
                Text(
                  widget.item['brand'].toString().toUpperCase(),
                  style: WriteStyles.headerSmall(context).copyWith(
                      fontSize: 15.sp,
                      color: Theme.of(context).colorScheme.secondary),
                ),

                GlobalVariables.spaceSmaller(),
                Text('\$${total.toString()}',
                    style: WriteStyles.headerMedium(context).copyWith(
                        color: Theme.of(context).colorScheme.tertiary)),
                GlobalVariables.spaceSmall(),
                // QUANTITY PICKER
                Row(
                  children: [
                    isCart
                        ? GlobalVariables.spaceSmaller(isWidth: true)
                        : Text('Quantity',
                            style: WriteStyles.headerSmall(context).copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                    isCart
                        ? const SizedBox()
                        : Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    quantity--;
                                    quantityHandler();
                                    if (total != widget.item['price']) {
                                      total =
                                          total - widget.item['price'] as int;
                                    }
                                    debugPrint('$quantity');
                                  });
                                },
                                icon: const Icon(CarbonIcons.subtract_alt),
                              ),
                              Text('${quantityHandler()}',
                                  style: WriteStyles.headerSmall(context)),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                    quantityHandler();
                                    total = total + widget.item['price'] as int;
                                    debugPrint('$quantity');
                                  });
                                },
                                icon: const Icon(CarbonIcons.add_alt),
                              ),
                            ],
                          ),
                    GlobalVariables.spaceSmall(isWidth: true),
                    // ADD TO CART BUTTON
                    isCart
                        ? Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                height: isCart ? 50.h : 40.h,
                                width: isCart ? 260.w : 140.w,
                                child: Center(
                                  child: Text(
                                    'Added to Cart',
                                    style: WriteStyles.bodyMedium(context)
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              Cart addItemtoCart = Cart(
                                  id: widget.id,
                                  quantity: quantity,
                                  total: total);

                              servicesProvider.addToCart(
                                  cartDetails: addItemtoCart);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 1270),
                                  content: Center(
                                    child: Text('Shoes added to cart',
                                        style: WriteStyles.bodyMedium(context)
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background)),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 40.h,
                              width: 140.w,
                              child: Center(
                                child: Text(
                                  'Add to Cart',
                                  style: WriteStyles.bodyMedium(context)
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                GlobalVariables.spaceSmall(),
                Text(widget.item['description'],
                    style: WriteStyles.bodyMedium(context).copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
