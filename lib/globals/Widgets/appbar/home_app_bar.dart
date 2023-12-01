
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import 'appbar.dart';

class NHomeAppBar extends StatelessWidget {
  const NHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text ("Rakibul Nasib", style: Theme.of (context).textTheme.headlineSmall?.apply(color: NColors.white)),
          Text ("Student", style: Theme.of(context).textTheme.labelMedium!.apply(color: NColors.grey)),
        ],
      ),
    );
  }
}

