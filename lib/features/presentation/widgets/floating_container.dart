import 'package:expense_app/core/util/theme_util.dart';
import 'package:flutter/material.dart';

class FloatingContainer extends StatelessWidget {

  final Widget child;
  final Function? onTap;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool shadowEnabled;

  const FloatingContainer({Key? key, required this.child, this.onTap, this.borderRadius = 12.0, this.shadowEnabled = false, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: shadowEnabled ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: InkWell(
            customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            splashColor: MyTheme.graySoft,
            onTap: (){
              if(onTap != null){
                onTap!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            )
        )
    );
  }
}
