import 'package:flutter/material.dart';

class SplashEffectWidget extends StatelessWidget {

  late ThemeData _theme;

  final Widget child;
  final Function? onTap;
  final Function? onLongPress;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? color;
  final Decoration? decoration;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  SplashEffectWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.splashColor,
    this.color,
    this.decoration,
    this.padding,
    this.height,
    this.width,
    this.margin,
    this.onLongPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Padding(
      padding: margin != null ? margin! : EdgeInsets.all(0),
      child: Ink(
          height: height,
          width: width,
          decoration: decoration ?? BoxDecoration(
            color: color,
            borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
          ),
          child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16))
              ),
              splashColor: splashColor ?? _theme.primaryColor,
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
              },
              onLongPress: onLongPress != null ? () {
                onLongPress!();
              } : null,
              child: padding != null ? Padding(
                  padding: padding!,
                  child: child
              ) : child
          )
      ),
    );
  }
}
