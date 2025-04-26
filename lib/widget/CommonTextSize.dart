import 'package:agni_chit_saving/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Commontextsize {
  static TextStyle CommonXsSize({Color? color}) {
    return GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: color ?? AppColors.TextBlackcolor,
    );
  }

  static TextStyle CommonSmallSize({Color? color}) {
    return GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
      color: color ?? AppColors.TextBlackcolor,
    );
  }

  static TextStyle CommonMediumSize({Color? color, }) {
    return GoogleFonts.lato(
      fontWeight: FontWeight.w900,
      fontSize: 15.0,
      color: color ?? AppColors.TextBlackcolor,
    );
  }

  static TextStyle CommonLargeSize({Color? color}) {
    return GoogleFonts.lato(
      fontWeight: FontWeight.w900,
      fontSize: 20.0,
      color: color ?? AppColors.TextBlackcolor,
    );
  }
}
