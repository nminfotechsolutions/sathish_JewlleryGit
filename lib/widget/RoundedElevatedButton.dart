import 'package:flutter/material.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

class RoundedElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final Widget? child;

  const RoundedElevatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Set the width of the container
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: backgroundColor != null
              ? MaterialStateProperty.all<Color>(backgroundColor!)
              : MaterialStateProperty.all<Color>(AppColors.CommonColor),
          foregroundColor: foregroundColor != null
              ? MaterialStateProperty.all<Color>(foregroundColor!)
              : MaterialStateProperty.all<Color>(AppColors.Textstylecolor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
          ),
          padding: padding != null
              ? MaterialStateProperty.all<EdgeInsetsGeometry>(padding!)
              : MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(6)), // Default padding
        ),
        child: child ?? Text(
          text,
          style: TextStyle(color: foregroundColor),
        ),
      ),
    );
  }
}
