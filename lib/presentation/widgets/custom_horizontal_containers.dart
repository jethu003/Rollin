import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';


class CustomHorizontalContainers extends StatelessWidget {
  final List<String>? movieNames; // Optional list of movie names
  final void Function(int index)? onPressed; // Optional onPressed callback
  final double height; // Optional height for flexibility
  final double containerWidth; // Optional container width
  final Color borderColor; // Optional border color

  const CustomHorizontalContainers({
    super.key,
    this.movieNames,
    this.onPressed,
    this.height = 40, // Default height
    this.containerWidth = 150, // Default width
    this.borderColor = AppColours.primaryColor, // Default border color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movieNames?.length ?? 10, // Default to 10 items
          itemBuilder: (context, index) {
            return Container(
              width: containerWidth,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () => onPressed?.call(index), // Call the callback if provided
                  child: Text(
                    movieNames?[index] ?? 'Moviename', // Fallback to 'Moviename'
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
