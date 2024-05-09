import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../font_styles.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool isNumber;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomTextField(
      {super.key,
      this.obscureText = false,
      this.inputFormatters,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.focusNode,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      focusNode: focusNode,
      keyboardType: isNumber == true ? TextInputType.number : null,
      inputFormatters: inputFormatters,
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

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length <= 16) {
      final newText = <String>[];
      for (var i = 0; i < text.length; i += 4) {
        newText.add(text.substring(i, i + 4));
      }
      return TextEditingValue(
        text: newText.join(' ').trim(),
        selection: TextSelection.collapsed(offset: newText.join(' ').length),
      );
    }
    return oldValue;
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text
        .replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters
    if (newText.length > 2) {
      newText = newText.substring(0, 2) + '/' + newText.substring(2);
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
