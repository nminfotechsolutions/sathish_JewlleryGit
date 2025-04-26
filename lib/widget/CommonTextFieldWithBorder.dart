import 'package:flutter/material.dart';
import 'package:agni_chit_saving/routes/app_export.dart';

class CommonTextFieldWithBorder extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final IconData? prefixIcon;

  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextAlign textAlign;
  final bool readOnly;
  final String? errorText;
  final int? maxlength;
  final bool showBorder;
  final FocusNode? focusNode;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconOnPressed;

  const CommonTextFieldWithBorder({
    super.key,
    this.suffixIconOnPressed,
    this.labelText,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.labelStyle = const TextStyle(
        fontWeight: FontWeight.w900, color: AppColors.CommonColor),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w900,
      letterSpacing: 1,
    ),
    this.hintStyle = const TextStyle(
      color: Colors.grey,
    ),
    this.suffixIcon,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.errorText,
    this.maxlength,
    this.showBorder = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        style: textStyle,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        maxLength: maxlength,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          labelText: labelText,
          labelStyle: labelStyle,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.CommonColor)
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: AppColors.CommonColor),
                  onPressed: suffixIconOnPressed,
                )
              : null,

          hintText: hintText,
          hintStyle: hintStyle,
          errorText: errorText,
          border: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )
              : InputBorder.none, // Conditional border
        ),
        keyboardType: keyboardType,
        textAlign: textAlign,
        readOnly: readOnly,
        focusNode: focusNode,
      ),
    );
  }
}
