import 'package:flutter/material.dart';

class IconUtil{

  static IconData getIconFromString(String icon){
    switch(icon){
      case 'Meal':
        return Icons.fastfood_rounded;
      case 'Food':
        return Icons.restaurant;
      case 'Drink':
        return Icons.coffee;
      case 'Laundry':
        return Icons.style;
      case 'E-Money':
        return Icons.credit_card;
      case 'E-Wallet':
        return Icons.monetization_on;
      case 'Tools':
        return Icons.home_repair_service;
      case 'Toiletries':
        return Icons.shower;
      case 'Electricity':
        return Icons.bolt;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Others':
        return Icons.menu;
      default:
        return Icons.fastfood_rounded;
    }
  }

}