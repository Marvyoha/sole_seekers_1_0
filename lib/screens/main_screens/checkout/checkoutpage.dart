import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      CarbonIcons.money,
      size: 60,
    ));
  }
}
