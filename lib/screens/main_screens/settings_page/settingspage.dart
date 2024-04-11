import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      CarbonIcons.settings,
      size: 60,
    ));
  }
}
