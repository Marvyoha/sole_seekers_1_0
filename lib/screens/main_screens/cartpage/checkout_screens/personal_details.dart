import 'package:flutter/material.dart';
import 'package:sole_seekers_1_0/constant/widgets/customButton2.dart';
import 'package:sole_seekers_1_0/constant/widgets/custom_textfield.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/global_variables.dart';
import '../widgets/process_showcase.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameOfReceipientController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Shipping Details',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Container(
        padding: GlobalVariables.normPadding,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProcessShowcase(
              isPersonalDetails: true,
            ),
            GlobalVariables.spaceMedium(),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            GlobalVariables.spaceMedium(),
            Text('Name of Recepient',
                style: WriteStyles.bodyMedium(context)
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            CustomTextField(
                hintText: 'Name', controller: nameOfReceipientController),
            GlobalVariables.spaceMedium(),
            Text('Address',
                style: WriteStyles.bodyMedium(context)
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            CustomTextField(
                hintText: 'Number/Street', controller: addressController),
            GlobalVariables.spaceMedium(),
            Text('City',
                style: WriteStyles.bodyMedium(context)
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            CustomTextField(hintText: 'City', controller: cityController),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Additional Shippng Fees',
                  style: WriteStyles.bodyMedium(context)
                      .copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
                Text(
                  ' \$ ${25.toString()}',
                  style: WriteStyles.bodyMedium(context).copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            GlobalVariables.spaceMedium(),
            CustomButton2(
              text: 'Continue to Payment',
              onTap: () => Navigator.pushNamed(context, 'cardDetails'),
            )
          ],
        ),
      ),
    );
  }
}
