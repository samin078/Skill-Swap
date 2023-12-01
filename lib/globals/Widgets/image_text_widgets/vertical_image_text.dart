import 'package:flutter/material.dart';

import '../../../helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class NVerticalImageText extends StatelessWidget {
  NVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textcolor = NColors.white,
    this.backgroundColor = NColors.white,
    this.onTap,
  });

  final String image, title;
  final Color textcolor;
  final Color? backgroundColor;
  final VoidCallback? onTap; // Corrected the declaration of onTap

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: NSizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: EdgeInsets.all(NSizes.sm),
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? NColors.black : NColors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image(image: AssetImage(image), fit: BoxFit.cover),
              ),
            ),


            ///text
            const SizedBox(height: NSizes.spaceBtwItems / 2),
            SizedBox(
                width: 55,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textcolor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }
}
