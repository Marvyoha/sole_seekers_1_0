import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/constant/widgets/customButton2.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';
import '../../../core/models/user_info.dart';
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
    int subTotal = 0, delivery = 7, grandTotal = 0;

    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    subTotal = servicesProvider.getSubTotal();

    grandTotal = subTotal + delivery;

    // servicesProvider.getCurrentUserDoc();
    // servicesProvider.getCatalogs();

    List<Map> cartListArray = servicesProvider.getCart();

    bool isCartEmpty() {
      if (servicesProvider.userDetails.cart.isEmpty) {
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
          : Column(
              children: [
                // CART LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: cartListArray.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = cartListArray[index];
                      final id = item['id'];

                      getDetails() {
                        Cart vari = Cart(id: 0, quantity: 0, total: 0);
                        for (Cart element
                            in servicesProvider.userDetails.cart) {
                          if (element.id == item['id']) {
                            vari = element;
                            break;
                          }
                        }
                        return vari;
                      }

                      Cart cartDetails = getDetails();
                      int? quantityHandler(int variable,
                          {bool isTotal = false}) {
                        if (isTotal == true) {
                          if (variable < item['price']) {
                            variable = item['price'];
                          }
                          return variable;
                        }
                        if (variable < 1) {
                          variable = 1;
                        }
                        return variable;
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
                                            style:
                                                WriteStyles.bodySmall(context)
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
                                                ' \$${cartDetails.total.toString()}',
                                                style: WriteStyles.bodySmall(
                                                        context)
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
                                                    onPressed: () {
                                                      int? quasiQuantity =
                                                          quantityHandler(
                                                              cartDetails
                                                                      .quantity -
                                                                  1);
                                                      int? quasiTotal =
                                                          quantityHandler(
                                                              isTotal: true,
                                                              cartDetails.total -
                                                                      item[
                                                                          'price']
                                                                  as int);

                                                      Cart addItemtoCart = Cart(
                                                        id: id,
                                                        quantity: quasiQuantity
                                                            as int,
                                                        total:
                                                            quasiTotal as int,
                                                      );

                                                      servicesProvider.addToCart(
                                                          cartDetails:
                                                              addItemtoCart);
                                                    },
                                                    icon: const Icon(CarbonIcons
                                                        .subtract_alt),
                                                  ),
                                                  Text(
                                                      '${cartDetails.quantity}',
                                                      style: WriteStyles
                                                          .headerSmall(
                                                              context)),
                                                  IconButton(
                                                    onPressed: () {
                                                      Cart addItemtoCart = Cart(
                                                          id: id,
                                                          quantity: cartDetails
                                                                  .quantity +
                                                              1,
                                                          total: cartDetails
                                                                      .total +
                                                                  item['price']
                                                              as int);

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
                                                  servicesProvider
                                                      .removeFromCart(id: id);
                                                },
                                                icon: const Icon(
                                                  CarbonIcons
                                                      .shopping_cart_error,
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
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: WriteStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          Text(
                            ' \$ ${subTotal.toString()}',
                            style: WriteStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      GlobalVariables.spaceSmall(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery',
                            style: WriteStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          Text(
                            ' \$ ${delivery.toString()}',
                            style: WriteStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      GlobalVariables.spaceSmall(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: WriteStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          Text(
                            ' \$ ${grandTotal.toString()}',
                            style: WriteStyles.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      GlobalVariables.spaceSmall(),
                      CustomButton2(
                        text: 'Checkout',
                        onTap: () {
                          Navigator.pushNamed(context, 'personalDetails');
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
