import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalVariables {
  static String appIcon = 'assets/SoleSeekers app icon.jpg';
  static String logo = 'assets/SoleSeekers Logo.png';
  static String onboardimage1 = 'assets/On boarding pic.png';
  static String onboardimage2 = 'assets/On boarding pic2.png';
  static String onboardimage3 = 'assets/On boarding pic3.png';
  static String brandLogo1 = 'assets/brand_icons/Nike logo.png';
  static String brandLogo2 = 'assets/brand_icons/Adidas logo.png';
  static String brandLogo3 = 'assets/brand_icons/Reebok logo.png';
  static String brandLogo4 = 'assets/brand_icons/Naked wolfe logo.png';
  static String brandLogo5 = 'assets/brand_icons/New balance logo.png';

  static double sizeHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double sizeWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static EdgeInsetsGeometry normPadding =
      const EdgeInsets.symmetric(horizontal: 20);
  static EdgeInsetsGeometry cardPadding = const EdgeInsets.all(10);
  static EdgeInsetsGeometry onBoardPadding =
      const EdgeInsets.fromLTRB(20, 0, 20, 0);

  static spaceLarge(BuildContext context, {bool isWidth = false}) {
    if (isWidth == true) {
      return SizedBox(width: sizeWidth(context) * 0.1);
    }
    return SizedBox(height: sizeHeight(context) * 0.1);
  }

  static spaceMedium({bool isWidth = false}) {
    if (isWidth == true) {
      return SizedBox(
        width: 30.w,
      );
    }
    return SizedBox(
      height: 30.h,
    );
  }

  static spaceSmall({bool isWidth = false}) {
    if (isWidth == true) {
      return SizedBox(
        width: 18.w,
      );
    }
    return SizedBox(
      height: 18.h,
    );
  }

  static spaceSmaller({bool isWidth = false}) {
    if (isWidth == true) {
      return SizedBox(
        width: 15.w,
      );
    }
    return SizedBox(
      height: 15.h,
    );
  }
}
