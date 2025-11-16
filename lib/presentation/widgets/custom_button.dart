import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final Size? buttonSize; // New parameter for custom button size

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.buttonColor,
    required this.textColor,
    required this.padding,
    this.buttonSize, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
          fixedSize: WidgetStateProperty.all<Size>(
            buttonSize ?? const Size(315.0, 55.0), // Default size if not provided
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: textColor,
                width: 0,
              ),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
