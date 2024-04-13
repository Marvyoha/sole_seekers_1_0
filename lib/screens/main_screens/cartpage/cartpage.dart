import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      CarbonIcons.shopping_cart,
      size: 60,
    ));
  }
}
