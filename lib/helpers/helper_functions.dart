import 'package:flutter/material.dart';

class NHelperFunctions{
  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

}