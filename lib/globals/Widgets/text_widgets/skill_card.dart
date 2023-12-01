import 'package:flutter/material.dart';
import 'dart:math';

class SkillCard2 extends StatelessWidget {
  final String skillName;
  final Color? cardColor;
  final double? textSize;
  final String? imagePath;

  SkillCard2({Key? key, required this.skillName, this.cardColor, this.textSize, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a random light color if no color is provided
    Color generateRandomLightColor() {
      Random random = Random();
      return Color.fromRGBO(
        150 + random.nextInt(100), // R value (150 to 250)
        150 + random.nextInt(100), // G value (150 to 250)
        150 + random.nextInt(100), // B value (150 to 250)
        0.9, // Opacity
      );
    }

    return Card(
      color: cardColor ?? generateRandomLightColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10), // Reduce padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image widget goes here
              if (imagePath != null)
                Image.asset(
                  imagePath!,
                  width: 50, // Adjust the width as needed
                  height: 50, // Adjust the height as needed
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              SizedBox(height: 5), // Add less spacing between image and text
              // Wrap the Text with FittedBox to handle overflow
              FittedBox(
                fit: BoxFit.scaleDown, // Scale down text if needed
                child: Text(
                  skillName,
                  maxLines: 1, // Display text in a single line
                  overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}