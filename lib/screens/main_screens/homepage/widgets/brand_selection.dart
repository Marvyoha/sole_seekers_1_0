import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

import '../../../../core/providers/query_provider.dart';

class BrandList extends StatefulWidget {
  const BrandList({super.key});

  @override
  State<BrandList> createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QueryProvider>(context, listen: true);
    return SizedBox(
      height: 80.h,
      child: Wrap(
        children: [
          BrandButton(
              onTap: () {
                qp.nike = !qp.nike;
                qp.adidas = false;
                qp.reebok = false;
                qp.nakedWolfe = false;
                qp.newBalance = false;

                qp.querySetter();
              },
              clickedBool: qp.nike,
              image: GlobalVariables.brandLogo1),
          BrandButton(
              onTap: () {
                qp.nike = false;
                qp.adidas = !qp.adidas;
                qp.reebok = false;
                qp.nakedWolfe = false;
                qp.newBalance = false;

                qp.querySetter();
              },
              clickedBool: qp.adidas,
              image: GlobalVariables.brandLogo2),
          BrandButton(
              onTap: () {
                qp.nike = false;
                qp.adidas = false;
                qp.reebok = !qp.reebok;
                qp.nakedWolfe = false;
                qp.newBalance = false;

                qp.querySetter();
              },
              clickedBool: qp.reebok,
              image: GlobalVariables.brandLogo3),
          BrandButton(
              onTap: () {
                qp.nike = false;
                qp.adidas = false;
                qp.reebok = false;
                qp.nakedWolfe = !qp.nakedWolfe;
                qp.newBalance = false;

                qp.querySetter();
              },
              clickedBool: qp.nakedWolfe,
              image: GlobalVariables.brandLogo4),
          BrandButton(
              onTap: () {
                qp.nike = false;
                qp.adidas = false;
                qp.reebok = false;
                qp.nakedWolfe = false;
                qp.newBalance = !qp.newBalance;

                qp.querySetter();
              },
              clickedBool: qp.newBalance,
              image: GlobalVariables.brandLogo5),
        ],
      ),
    );
  }
}

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
