// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/core/models/user_info.dart';
import 'package:sole_seekers_1_0/screens/main_screens/cartpage/widgets/process_showcase.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/global_variables.dart';
import '../../../../constant/widgets/custom_button.dart';
import '../../../../constant/widgets/custom_textfield.dart';
import '../../../../core/providers/services_provider.dart';

class CardDetails extends StatefulWidget {
  final String nameOfReceipient;
  final String address;
  final String city;
  final int phoneNumber;
  const CardDetails(
      {super.key,
      required this.nameOfReceipient,
      required this.address,
      required this.city,
      required this.phoneNumber});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  bool isCard = true;

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: true);
    int grandTotal = servicesProvider.getSubTotal() + 25;

    String generateTransactionId() {
      final random = Random();
      const chars =
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      const idLength = 16;

      return String.fromCharCodes(Iterable.generate(
        idLength,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ));
    }

    String formatDateTime(DateTime dateTime) {
      String formattedDate =
          '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      String period = dateTime.hour < 12 ? 'AM' : 'PM';
      int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      String formattedTime = '$hour:${dateTime.minute} $period';
      return '$formattedDate - $formattedTime';
    }

    uploadPurchaseHistory() {
      Future.delayed(const Duration(seconds: 3), () {
        Location location =
            Location(address: widget.address, city: widget.city);
        PurchaseHistory purchased = PurchaseHistory(
          nameOfRecipient: widget.nameOfReceipient,
          purchaseId: generateTransactionId(),
          orderedItems: servicesProvider.userDetails!.cart,
          phoneNumber: widget.phoneNumber,
          grandTotal: grandTotal,
          timeOrdered: formatDateTime(DateTime.now()),
          location: location,
        );

        servicesProvider.userDetails!.purchaseHistory.add(purchased);
        servicesProvider.userDetails!.cart = [];
        servicesProvider.updateUserDetails();
        servicesProvider.loader = false;
        Navigator.pushReplacementNamed(context, 'mainNav');
        Navigator.pushNamed(context, 'confirmationPage');
      });
    }

    cardValidationChecker() {
      if (cardNumberController.text.isEmpty ||
          expiryDateController.text.isEmpty ||
          cvvController.text.isEmpty) {
        servicesProvider.loader = false;
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Center(
              child: Text(
                'Fill All Criterias.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else if (cardNumberController.text.length < 19 ||
          expiryDateController.text.length < 5 ||
          cvvController.text.length < 3) {
        servicesProvider.loader = false;
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Center(
              child: Text(
                'Filled detail(s) is badly formatted.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }
      uploadPurchaseHistory();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Payment',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: GlobalVariables.normPadding,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              ProcessShowcase(
                isPersonalDetails: true,
                isCardDetails: true,
              ),
              GlobalVariables.spaceMedium(),
              //CASH PAYMENT
              PaymentSelector(
                checker: isCard,
                onTap: () {
                  isCard = false;
                  setState(() {});
                },
              ),
              GlobalVariables.spaceMedium(),
              // CARD PAYMENT
              PaymentSelector(
                checker: isCard,
                isCard: true,
                onTap: () {
                  isCard = true;
                  setState(() {});
                },
              ),
              GlobalVariables.spaceMedium(),
              isCard == true
                  ? Padding(
                      padding: GlobalVariables.normPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card Number',
                              style: WriteStyles.bodyMedium(context).copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          GlobalVariables.spaceSmaller(),
                          CustomTextField(
                            hintText: '',
                            isNumber: true,
                            controller: cardNumberController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              CardNumberInputFormatter(),
                            ],
                          ),
                          GlobalVariables.spaceMedium(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Expiry Date',
                                      style: WriteStyles.bodyMedium(context)
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                  GlobalVariables.spaceSmaller(),
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.w,
                                    child: CustomTextField(
                                      hintText: 'MM/YY',
                                      isNumber: true,
                                      controller: expiryDateController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                        ExpiryDateFormatter()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CVV/CVC',
                                      style: WriteStyles.bodyMedium(context)
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                  GlobalVariables.spaceSmaller(),
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.w,
                                    child: CustomTextField(
                                      hintText: '',
                                      isNumber: true,
                                      controller: cvvController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              GlobalVariables.spaceLarge(context),
              isCard == false
                  ? GlobalVariables.spaceLarge(context)
                  : const SizedBox(),
              isCard == false
                  ? GlobalVariables.spaceLarge(context)
                  : const SizedBox(),
              isCard == false
                  ? GlobalVariables.spaceMedium()
                  : const SizedBox(),
              isCard == false ? GlobalVariables.spaceSmall() : const SizedBox(),
              GlobalVariables.spaceMedium(),
              GlobalVariables.spaceMedium(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                color: Theme.of(context).colorScheme.background,
                child: CustomButton(
                  isLoading: servicesProvider.loader,
                  text: 'Continue Order - \$$grandTotal',
                  onTap: () {
                    servicesProvider.loader = true;
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (isCard) {
                        cardValidationChecker();
                      } else {
                        uploadPurchaseHistory();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentSelector extends StatefulWidget {
  bool checker;
  bool isCard;
  final void Function()? onTap;

  PaymentSelector({
    super.key,
    required this.checker,
    this.isCard = false,
    this.onTap,
  });

  @override
  State<PaymentSelector> createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<PaymentSelector> {
  @override
  Widget build(BuildContext context) {
    return widget.isCard == false
        ? GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.checker == false
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(10)),
              height: 49.h,
              width: 301.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payments,
                    color: widget.checker == false
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primary,
                  ),
                  GlobalVariables.spaceSmall(isWidth: true),
                  Text(
                    'Cash Payment',
                    style: WriteStyles.bodyMedium(context).copyWith(
                        color: widget.checker == false
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.checker == true
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(10)),
              height: 49.h,
              width: 301.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    color: widget.checker == true
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primary,
                  ),
                  GlobalVariables.spaceSmall(isWidth: true),
                  Text(
                    'Card Payment',
                    style: WriteStyles.bodyMedium(context).copyWith(
                        color: widget.checker == true
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          );
  }
}
