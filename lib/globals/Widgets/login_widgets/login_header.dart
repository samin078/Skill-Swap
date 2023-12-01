import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';



class NLoginHeader extends StatelessWidget {
  const NLoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image(
            height: 150,
            image: AssetImage(dark
                ? "assets/logos/logo.png"
                : "assets/logos/logo.png"),
          ),
        ),
        Center(
          child: Text(
            "Welcome to SkillSwap",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(
          height: NSizes.sm,
        ),
        Center(
          child: Text(
            "Share Knowledge Like You Have Never Before",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
