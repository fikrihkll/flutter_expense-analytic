import 'package:flutter/material.dart';

class CenterPadding extends StatelessWidget {

  final Widget child;

  const CenterPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
