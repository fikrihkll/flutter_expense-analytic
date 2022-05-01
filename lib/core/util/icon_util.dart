import 'package:flutter/material.dart';

class IconUtil{

  static IconData getIconFromString(String icon){
    switch(icon){
      case 'Meal':
        return Icons.fastfood_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

}