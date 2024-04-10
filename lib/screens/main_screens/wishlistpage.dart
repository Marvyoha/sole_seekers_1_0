import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      CarbonIcons.star,
      size: 60,
    ));
  }
}
