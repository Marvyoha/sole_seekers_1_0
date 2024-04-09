import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteStyles {
  static TextStyle headerLarge(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 25.sp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle headerMedium(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle headerSmall(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 13.sp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle cardHeader(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle cardSubtitle(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle hintText(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.poppins(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    );
  }
}
