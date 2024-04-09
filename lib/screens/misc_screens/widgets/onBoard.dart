import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/global_variables.dart';

class OnBoard extends StatelessWidget {
  final String image;
  final String phrase;
  const OnBoard({super.key, required this.image, required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: GlobalVariables.normPadding,
      child: Column(
        children: [
          Container(
            height: 200.h,
            width: 240.w,
            child: Image.asset(GlobalVariables.logo,
                color: Theme.of(context).colorScheme.primary),
          ),
          Text(
            phrase,
            textAlign: TextAlign.start,
            style: WriteStyles.headerLarge(context).copyWith(fontSize: 29.sp),
          ),
          Container(
              height: 280.h,
              width: 320.w,
              child: Image.asset(
                image,
              )),
        ],
      ),
    );
  }
}
