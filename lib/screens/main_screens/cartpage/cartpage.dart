import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/core/models/user_info.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';
import '../../../core/providers/services_provider.dart';
import '../../misc_screens/product_details_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    int subTotal = 0, delivery = 0, grandTotal = 0;

    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    subTotal = servicesProvider.getSubTotal();
    delivery = Random().nextInt(21) + 10;
    grandTotal = subTotal + delivery;

    // servicesProvider.getCurrentUserDoc();
    // servicesProvider.getCatalogs();

    List<Map> cartListArray = servicesProvider.getCart();

    bool isCartEmpty() {
      if (servicesProvider.userDetails!.cart.isEmpty) {
        return true;
      } else {
        return false;
      }
    }

    bool isEmpty = isCartEmpty();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Shopping Cart',
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
                      CarbonIcons.shopping_cart_clear,
                      size: 90,
                    ),
                    GlobalVariables.spaceMedium(),
                    Text(
                      'Cart is Empty,\n Go Shopping!!',
                      textAlign: TextAlign.center,
                      style: WriteStyles.headerMedium(context)
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: cartListArray.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = cartListArray[index];
                  final id = item['id'];

                  int assignTotal() {
                    int vari = 0;
                    for (Cart element in servicesProvider.userDetails!.cart) {
                      if (element.id == item['id']) {
                        vari = element.total;
                        break;
                      }
                    }
                    return vari;
                  }

                  int assignQuantity() {
                    int vari = 0;
                    for (Cart element in servicesProvider.userDetails!.cart) {
                      if (element.id == item['id']) {
                        vari = element.quantity;
                        break;
                      }
                    }
                    return vari;
                  }

                  int total = assignTotal();
                  int quantity = assignQuantity();
                  int? quantityHandler() {
                    if (quantity < 1) {
                      quantity = 1;
                    }
                    return quantity;
                  }

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
                                            ' \$${total.toString()}',
                                            style:
                                                WriteStyles.bodySmall(context)
                                                    .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    CarbonIcons.subtract_alt),
                                              ),
                                              Text('${quantity}',
                                                  style:
                                                      WriteStyles.headerSmall(
                                                          context)),
                                              IconButton(
                                                onPressed: () {
                                                  quantity = quantity + 1;
                                                  quantityHandler();
                                                  total = (quantity *
                                                      int.parse(item['price']));
                                                  Cart addItemtoCart = Cart(
                                                      id: item[id],
                                                      quantity: quantity,
                                                      total: total);

                                                  servicesProvider.addToCart(
                                                      cartDetails:
                                                          addItemtoCart);
                                                },
                                                icon: const Icon(
                                                    CarbonIcons.add_alt),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              servicesProvider.removeFromCart(
                                                  id: id);
                                            },
                                            icon: const Icon(
                                              CarbonIcons.shopping_cart_error,
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
              )

        // bottomSheet: Container(
        //   padding: GlobalVariables.normPadding,
        //   height: 200.h,
        //   color: Colors.transparent,
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             'Subtotal',
        //             style: WriteStyles.bodyMedium(context)
        //                 .copyWith(color: Theme.of(context).colorScheme.tertiary),
        //           ),
        //           Text(
        //             ' \$ ${subTotal.toString()}',
        //             style: WriteStyles.bodyMedium(context).copyWith(
        //                 color: Theme.of(context).colorScheme.primary,
        //                 fontWeight: FontWeight.bold),
        //           )
        //         ],
        //       ),
        //       GlobalVariables.spaceSmall(),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             'Delivery',
        //             style: WriteStyles.bodyMedium(context)
        //                 .copyWith(color: Theme.of(context).colorScheme.tertiary),
        //           ),
        //           Text(
        //             ' \$ ${delivery.toString()}',
        //             style: WriteStyles.bodyMedium(context).copyWith(
        //                 color: Theme.of(context).colorScheme.primary,
        //                 fontWeight: FontWeight.bold),
        //           )
        //         ],
        //       ),
        //       GlobalVariables.spaceSmall(),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             'Total',
        //             style: WriteStyles.bodyMedium(context)
        //                 .copyWith(color: Theme.of(context).colorScheme.tertiary),
        //           ),
        //           Text(
        //             ' \$ ${grandTotal.toString()}',
        //             style: WriteStyles.bodyMedium(context).copyWith(
        //                 color: Theme.of(context).colorScheme.primary,
        //                 fontWeight: FontWeight.bold),
        //           )
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
