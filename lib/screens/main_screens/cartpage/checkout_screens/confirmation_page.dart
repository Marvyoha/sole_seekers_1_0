import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/constant/widgets/custom_button.dart';
import 'package:sole_seekers_1_0/core/models/user_info.dart';
import 'package:sole_seekers_1_0/screens/misc_screens/purchase_history_details.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/global_variables.dart';
import '../../../../core/providers/services_provider.dart';
import '../widgets/process_showcase.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    PurchaseHistory yourPurchase =
        servicesProvider.userDetails!.purchaseHistory.last;
    int total = yourPurchase.grandTotal;
    int delivery = 25;
    int subtotal = total - delivery;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: const SizedBox(),
        title: Text(
          'Confirmation',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Container(
        padding: GlobalVariables.normPadding,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            ProcessShowcase(
              isPersonalDetails: true,
              isCardDetails: true,
              isConfirmation: true,
            ),
            GlobalVariables.spaceLarge(context),
            const Icon(
              CarbonIcons.shopping_bag,
              size: 120,
            ),
            GlobalVariables.spaceSmall(),
            Text(
                'Hey ${yourPurchase.nameOfRecipient},\n Thank you for your purchase.',
                textAlign: TextAlign.center,
                style: WriteStyles.bodyMedium(context).copyWith(
                    fontSize: 20.sp,
                    color: Theme.of(context).colorScheme.primary)),
            GlobalVariables.spaceSmall(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SubTotal',
                  style: WriteStyles.bodyMedium(context)
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  ' \$ ${subtotal.toString()}',
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
                  style: WriteStyles.bodyMedium(context)
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  ' \$ ${delivery.toString()}',
                  style: WriteStyles.bodyMedium(context).copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(),
            GlobalVariables.spaceSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: WriteStyles.bodyMedium(context)
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  ' \$ ${total.toString()}',
                  style: WriteStyles.bodyMedium(context).copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            GlobalVariables.spaceMedium(),
            CustomButton(
                text: 'Order Details',
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'mainNav');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PurchaseHistoryDetails(
                            isFromConfirmPage: true, details: yourPurchase)),
                  );
                }),
            GlobalVariables.spaceMedium(),
            GlobalVariables.spaceMedium(),
            Flexible(
              child: CustomButton(
                text: 'Continue Shopping',
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'mainNav');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
