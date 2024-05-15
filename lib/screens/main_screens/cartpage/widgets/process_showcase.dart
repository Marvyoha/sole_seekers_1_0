// ignore_for_file: must_be_immutable

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcessShowcase extends StatelessWidget {
  bool isPersonalDetails;
  bool isCardDetails;
  bool isConfirmation;

  ProcessShowcase(
      {super.key,
      this.isPersonalDetails = false,
      this.isCardDetails = false,
      this.isConfirmation = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_pin,
          color: isPersonalDetails
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          size: 35,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Icon(
          Icons.payment_rounded,
          color: isCardDetails
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          size: 35,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Container(
          color: Theme.of(context).colorScheme.primary,
          width: 22.w,
          height: 1.h,
        ),
        SizedBox(width: 5.w),
        Icon(
          CarbonIcons.checkmark_filled,
          color: isConfirmation
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          size: 35,
        ),
      ],
    );
  }
}
