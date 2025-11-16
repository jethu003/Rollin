import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';

class AppPlaceholderGrid extends StatelessWidget {
  final int itemCount; // number of placeholder boxes
  final double aspectRatio; // shape of the box
  final double spacing; // spacing between items
  final double runSpacing;
  final Color baseColor; 
  final bool showTextLines; // show text lines below box or not

  const AppPlaceholderGrid({
    super.key,
    this.itemCount = 6,
    this.aspectRatio = 0.66, // 2:3 aspect ratio (movie poster)
    this.spacing = 12,
    this.runSpacing = 12,
    this.baseColor = AppColours.primaryColor,
    this.showTextLines = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    double itemWidth =
        (width - (spacing * 2) - (width * 0.06)) / 2; // 2 items per row
    double itemHeight = itemWidth / aspectRatio;

    return SingleChildScrollView(
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: List.generate(
          itemCount,
          (index) => SizedBox(
            width: itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 Poster placeholder
                Container(
                  width: itemWidth,
                  height: itemHeight,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                ),
                if (showTextLines) ...[
                  const SizedBox(height: 8),
                  // Title
                  Container(
                    height: 12,
                    width: itemWidth * 0.7,
                    decoration: BoxDecoration(
                      color: baseColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Language
                  Container(
                    height: 10,
                    width: itemWidth * 0.4,
                    decoration: BoxDecoration(
                      color: baseColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Genre
                  Container(
                    height: 10,
                    width: itemWidth * 0.6,
                    decoration: BoxDecoration(
                      color: baseColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
