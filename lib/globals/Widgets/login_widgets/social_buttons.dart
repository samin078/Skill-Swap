import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';


class NSocialButtons extends StatelessWidget {
  const NSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: NColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: InkWell(
            onTap: () {
              // Add your functionality for when the Google icon is clicked here
            },
            child: Image.asset(
              'assets/logos/search.png', // Replace with the correct path to your Google icon image
              width: 35,
              height: 35, // Set the desired width
              // Set the desired height
            ),
          ),
        ),
      ],
    );
  }
}

