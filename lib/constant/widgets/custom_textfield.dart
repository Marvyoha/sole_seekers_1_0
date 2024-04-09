import 'package:flutter/material.dart';

import '../font_styles.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? hintText;
  final TextEditingController? controller;

  const CustomTextField(
      {super.key,
      this.obscureText = false,
      required this.hintText,
      required this.controller,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: WriteStyles.hintText(context),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.3),
        ),
      ),
    );
  }
}
