import 'package:flutter/material.dart';

import '../../helpers/Utility/device_utility.dart';
import '../../helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class NSearchContainer extends StatelessWidget {
  const NSearchContainer({
    super.key, required this.text, this.icon = Icons.search, this.showBackground = true, this.showBorder = true
  });
  final String text;
  final IconData? icon;
  final bool showBackground,showBorder;

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: NSizes.defaultSpace),
      child: Container(
        width:NDeviceUtils.getScreenWidth(context),
        padding: EdgeInsets.all(NSizes.md),
        decoration: BoxDecoration(
          color: showBackground ? dark ? NColors.dark : NColors.light:  Colors.transparent,
          borderRadius: BorderRadius.circular(NSizes.cardRadiusLg),
          border: showBorder ? Border.all(color: NColors.grey): null,

        ),
        child: Row(
          children: [
            Icon(icon!,color: NColors.grey,),
            SizedBox(width: NSizes.spaceBtwItems,),
            Text(text,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NColors.grey),),
          ],
        ),
      ),
    );
  }
}

