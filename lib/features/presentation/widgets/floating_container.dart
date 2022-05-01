import 'package:expense_app/core/util/theme_util.dart';
import 'package:flutter/material.dart';

class FloatingContainer extends StatelessWidget {

  final Widget child;
  final Function? onTap;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool shadowEnabled;
  final bool splashEnabled;
  final Color? backgroundColor;
  final Color? splashColor;
  final Border? border;
  final EdgeInsetsGeometry? padding;

  const FloatingContainer({Key? key,
    required this.child,
    this.onTap,
    this.borderRadius = 12.0,
    this.shadowEnabled = false,
    this.width,
    this.height,
    this.splashEnabled = true,
    this.backgroundColor,
    this.splashColor,
    this.border,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? _theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: border,
          boxShadow: shadowEnabled ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: splashEnabled ? _buildChildWithSplashEffect()
            : _buildChild()
    );
  }

  Widget _buildChildWithSplashEffect(){
    return InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        splashColor: splashColor ?? MyTheme.primary,
        onTap: (){
          if(onTap != null){
            onTap!();
          }
        },
        child: _buildChild()
    );
  }

  Widget _buildChild(){
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}
