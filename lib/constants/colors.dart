import 'package:agni_chit_saving/routes/app_export.dart';

class AppColors {
  static const Color AppbarColor = Color(0xFF006476);
  static const Color SidebarColor = Color(0xFF0097B2);
  static const Color BodyColor = Color(0xFFF8F9F9);
  static const Color ButtonColorYes = Colors.green;
  static const Color ButtonColorNo = Colors.red;
  static const Color CommonColor = Color(0xFF24344D);
  static const Color Textcolor = Color(0xFF24344D);
  static const Color Textstylecolor = Colors.white;
  static const Color CommonBlack = Colors.black;
  static const Color TextBlackcolor = Colors.black;
  static const Color CommonRed = Colors.red;
  static const Color CommonGreen = Colors.green;
  static const Color CommonGrey = Colors.grey;
  static const Color CommonamberAccent = Colors.amberAccent;
}

TextStyle commonTextStyleExtraSmall({Color? color}) {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: color ?? AppColors.Textstylecolor,
  );
}

TextStyle commonTextStyleSmall({Color? color}) {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: color ?? AppColors.Textstylecolor,
  );
}

TextStyle commonTextStyleMedium({Color? color}) {
  return GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: color ?? AppColors.Textstylecolor,
  );
}

TextStyle commonTextStyleLarge({Color? color}) {
  return GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: color ?? AppColors.Textstylecolor,
  );
}

TextStyle commonTextStyleExtraLarge({Color? color}) {
  return GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: color ?? AppColors.Textstylecolor,
  );
}
