import 'package:flutter/material.dart';
import 'dart:math';

class SkillCard extends StatelessWidget {
  final String skillName;
  final Color? cardColor;

  SkillCard({Key? key, required this.skillName, this.cardColor}) : super(key: key);

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
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          skillName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
