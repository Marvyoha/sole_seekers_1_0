import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import '../../core/models/user_info.dart';
import '../../core/providers/services_provider.dart';
import 'product_details_page.dart';

class PurchaseHistoryDetails extends StatelessWidget {
  final PurchaseHistory details;
  final bool isFromConfirmPage;
  const PurchaseHistoryDetails(
      {super.key, required this.details, this.isFromConfirmPage = false});

  @override
  Widget build(BuildContext context) {
    ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
    getOrderedItems() {
      List orderedItems = [];
      for (Cart item in details.orderedItems) {
        for (var element in servicesProvider.catalogs!) {
          if (element['id'] == item.id) {
            orderedItems.add(element.data() as Map<dynamic, dynamic>);
          }
        }
      }
      return orderedItems;
    }

    List orderedItems = getOrderedItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => isFromConfirmPage == true
                ? Navigator.pushReplacementNamed(context, 'mainNav')
                : Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
            )),
        title: Text(
          'Purchase Details',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: GlobalVariables.normPadding,
          color: Theme.of(context).colorScheme.background,
          width: GlobalVariables.sizeWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Text(
                        'Purchased by \n${details.nameOfRecipient}',
                        textAlign: TextAlign.center,
                        style: WriteStyles.headerMedium(context).copyWith(
                            fontSize: 18.sp,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      GlobalVariables.spaceSmaller(),
                      Text(
                        '${details.location.address},${details.location.city}',
                        textAlign: TextAlign.center,
                        style: WriteStyles.headerMedium(context).copyWith(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    ],
                  ),
                ),
              ),
              GlobalVariables.spaceMedium(),
              // ORDER DETAILS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalVariables.spaceSmall(),
                  Text(
                    'Order Details',
                    textAlign: TextAlign.center,
                    style: WriteStyles.headerMedium(context).copyWith(
                        fontSize: 18.sp,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const Divider(),
                  OrderDetailsInfo(
                      infoHeader: 'Order ID', information: details.purchaseId),
                  GlobalVariables.spaceSmall(),
                  OrderDetailsInfo(
                      infoHeader: 'Order Date',
                      information: details.timeOrdered),
                  GlobalVariables.spaceSmall(),
                  OrderDetailsInfo(
                      infoHeader: 'Recipient',
                      information: details.nameOfRecipient),
                  GlobalVariables.spaceSmall(),
                  OrderDetailsInfo(
                      infoHeader: 'Phone Number',
                      information: details.phoneNumber.toString()),
                  GlobalVariables.spaceSmall(),
                  OrderDetailsInfo(
                      infoHeader: 'Grand total',
                      information: '\$${details.grandTotal}'),
                  const Divider(),
                ],
              ),
              GlobalVariables.spaceMedium(),
              Text(
                'Ordered Items - ${details.orderedItems.length}',
                textAlign: TextAlign.center,
                style: WriteStyles.headerMedium(context).copyWith(
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.primary),
              ),
              GlobalVariables.spaceSmall(),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 90.h * orderedItems.length * 1.2,
                    child: ListView.builder(
                      itemCount: orderedItems.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = orderedItems[index];
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
                                                      .primary);
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Qty: ',
                                                        style: WriteStyles
                                                            .headerSmall(
                                                                context)),
                                                    Text(
                                                        '${details.orderedItems[index].quantity}',
                                                        style: WriteStyles
                                                            .headerSmall(
                                                                context)),
                                                  ],
                                                ),
                                                Text(
                                                  ' \$${details.orderedItems[index].total}',
                                                  style: WriteStyles.bodySmall(
                                                          context)
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailsInfo extends StatelessWidget {
  final String infoHeader;
  final String information;
  const OrderDetailsInfo(
      {super.key, required this.infoHeader, required this.information});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          infoHeader,
          style: WriteStyles.bodyMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        Text(
          information,
          style: WriteStyles.bodyMedium(context).copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
