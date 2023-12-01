import 'package:flutter/material.dart';

class NDeviceUtils {
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
