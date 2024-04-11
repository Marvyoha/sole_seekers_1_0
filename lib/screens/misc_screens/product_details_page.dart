import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sole_seekers_1_0/constant/font_styles.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';
import 'package:sole_seekers_1_0/constant/widgets/custom_button.dart';

import '../../core/models/shoes_model.dart';

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
  int quantity = 0;
  bool isLimitReached = false;
  bool isWishlisted = false;

  int quantityHandler() {
    if (quantity < 0) {
      setState(() {
        quantity = 0;
      });
      return quantity;
    } else if (quantity >= 5) {
      setState(() {
        quantity = 5;
        isLimitReached = true;
      });
      return quantity;
    }
    isLimitReached = false;
    debugPrint('$quantity');
    return quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10)),
            height: 49.h,
            width: 250.w,
            child: Center(
              child: Text(
                'Add to Cart',
                style: WriteStyles.bodyMedium(context)
                    .copyWith(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isWishlisted = !isWishlisted;
                });
              },
              icon: Icon(
                isWishlisted ? CarbonIcons.star_filled : CarbonIcons.star,
                size: 40,
              ))
        ],
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
                GlobalVariables.spaceMedium(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Hero(
                    tag: 'CatalogItem ${widget.id}',
                    child: CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: widget.item['image'],
                      width: 343.w,
                      height: 286.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GlobalVariables.spaceMedium(),
                Text(
                  widget.item['name'],
                  style: WriteStyles.headerMedium(context),
                ),
                GlobalVariables.spaceSmaller(),
                Text('\$${widget.item['price'].toString()}',
                    style: WriteStyles.headerMedium(context)),
                GlobalVariables.spaceSmall(),
                // QUANTITY PICKER
                Row(
                  children: [
                    Text('Quantity',
                        style: WriteStyles.headerSmall(context).copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity--;
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
                            });
                          },
                          icon: const Icon(CarbonIcons.add_alt),
                        ),
                      ],
                    ),
                    isLimitReached
                        ? Text('Limit reached',
                            style: WriteStyles.headerSmall(context)
                                .copyWith(color: Colors.red))
                        : const SizedBox()
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
