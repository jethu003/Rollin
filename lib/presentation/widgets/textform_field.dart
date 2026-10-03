import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String) onTextChanged;
  final Icon icon;
  final bool isPasswordField;
  final Widget? suffixIcon;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.onTextChanged,
    required this.icon,
    this.isPasswordField = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onTextChanged,
      validator: validator,
      obscureText: isPasswordField,
      cursorWidth: 2,
      cursorColor: AppColours.insideGrey,
      style: const TextStyle(
        color: AppColours.insideGrey,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        prefixIcon: icon,

        //  THIS LINE FIXES EVERYTHING
        suffixIcon: suffixIcon,

        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColours.insideGrey,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: AppColours.shineBlack,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColours.shineWhite),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColours.shineWhite),
        ),
      ),
    );
  }
}
