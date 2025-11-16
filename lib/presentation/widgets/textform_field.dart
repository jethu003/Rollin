import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';



class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String) onTextChanged;
  final Icon icon;  
  final bool isPasswordField;  

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.onTextChanged,
    required this.icon,  
    this.isPasswordField = false,  
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onTextChanged,
      validator: validator,
      cursorWidth: 2,
      cursorColor: AppColours.insideGrey,
      controller: controller,
      obscureText: isPasswordField,  
      style: const TextStyle(color: AppColours.insideGrey,
      fontSize: 14
      ),
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: const TextStyle(color:AppColours.insideGrey,fontSize: 13,fontWeight: FontWeight.normal), 
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
