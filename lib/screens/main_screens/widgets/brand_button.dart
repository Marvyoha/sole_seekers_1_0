import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

class BrandButton extends StatelessWidget {
  final void Function()? onTap;
  final bool clickedBool;
  final String image;
  const BrandButton(
      {super.key,
      required this.onTap,
      required this.clickedBool,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 4,
          color: clickedBool
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            height: 55.h,
            width: 52.w,
            child: Image.asset(
              image,
              color: clickedBool
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.primary,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
