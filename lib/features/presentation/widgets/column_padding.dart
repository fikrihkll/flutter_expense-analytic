import 'package:flutter/material.dart';

class ColumnPadding extends StatelessWidget {
  
  final Widget child;
  bool? left;
  bool? right;
  ColumnPadding({Key? key, required this.child, this.left, this.right}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var padding = const EdgeInsets.symmetric(horizontal: 16);
    if (left != null) {
      padding = const EdgeInsets.only(left: 16);
    }
    if (right != null) {
      padding = const EdgeInsets.only(right: 16);
    }
    return Padding(
        padding: padding,
        child: child,    
    );
  }
}
