import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sole_seekers_1_0/constant/widgets/customButton2.dart';
import 'package:sole_seekers_1_0/constant/widgets/custom_textfield.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/global_variables.dart';
import '../widgets/process_showcase.dart';
import 'payment_details.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameOfReceipientController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController cityController = TextEditingController();

    validationChecker() {
      if (nameOfReceipientController.text.isEmpty ||
          addressController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          cityController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                'Fill All Criterias.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CardDetails(
              nameOfReceipient: nameOfReceipientController.text,
              address: addressController.text,
              city: cityController.text,
              phoneNumber: int.parse(phoneNumberController.text),
            ),
          ),
        );
      }
    }

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
      body: SingleChildScrollView(
        child: Container(
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
              Text('PhoneNumber',
                  style: WriteStyles.bodyMedium(context)
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
              CustomTextField(
                  hintText: 'Phone Number',
                  isNumber: true,
                  controller: phoneNumberController),
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
              GlobalVariables.spaceMedium(),
              GlobalVariables.spaceMedium(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlobalVariables.spaceMedium(),
                    CustomButton2(
                      text: 'Continue to Payment',
                      onTap: () => validationChecker(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
