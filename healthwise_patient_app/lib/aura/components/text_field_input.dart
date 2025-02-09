import 'package:flutter/material.dart';

import 'colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput({
    super.key,
    required this.hintText,
    this.isPass = false,
    required this.textEditingController,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.mediumGray),
        filled: true,
        fillColor: AppColors.veryLightPink,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.lightPink, width: 4),
        ),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: const TextStyle(color: AppColors.mediumGray),
    );
  }
}
