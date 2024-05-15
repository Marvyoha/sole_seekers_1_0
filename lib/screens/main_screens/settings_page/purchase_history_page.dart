// ignore_for_file: unnecessary_string_interpolations

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/core/providers/services_provider.dart';
import 'package:sole_seekers_1_0/screens/misc_screens/purchase_history_details.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

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
                    'Loading Purchase History..',
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

          bool isPurchaseHistoryEmpty() {
            if (servicesProvider.userDetails!.purchaseHistory.isEmpty) {
              return true;
            } else {
              return false;
            }
          }

          bool isEmpty = isPurchaseHistoryEmpty();
          return isEmpty
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
                        'No previous purchases,\n Go Shopping!!',
                        textAlign: TextAlign.center,
                        style: WriteStyles.headerMedium(context)
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    GlobalVariables.spaceSmall(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: servicesProvider
                            .userDetails!.purchaseHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = servicesProvider
                              .userDetails!.purchaseHistory[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: GlobalVariables.normPadding,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PurchaseHistoryDetails(
                                                      details: item))),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          children: [
                                            GlobalVariables.spaceSmall(
                                                isWidth: true),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Order ID: ${item.purchaseId}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        WriteStyles.bodySmall(
                                                                context)
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
                                                      Text(
                                                        'Name: ${item.nameOfRecipient} \n${item.timeOrdered}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: WriteStyles
                                                                .bodySmall(
                                                                    context)
                                                            .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        '\$${item.grandTotal.toString()}',
                                                        style: WriteStyles
                                                                .bodySmall(
                                                                    context)
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Purchase History',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: mainBody(),
    );
  }
}
