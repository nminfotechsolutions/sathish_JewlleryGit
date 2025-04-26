import 'package:agni_chit_saving/routes/app_export.dart';

class commonUtils {
  static DateTime selectedDate = DateTime.now();

  static final Logger log = Logger();

  static String otp = "";

  static String forgetMobNo = "";

  static String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    return "$day-$month-$year";
  }


  static String formatDateWithYMD(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static Future<String?> getPrefsCompanyId() async {
    return SharedPreferencesHelper.getString("prefsCompanyID");
  }

  static String PrefsCompanyId = SharedPreferencesHelper.getString("companyid");

  static Map<String, String> userData = {};

  static bool validateTextField(
      TextEditingController controller, bool validateFlag) {
    return controller.text.isEmpty;
  }

  static void showToast(String message,
      {ToastGravity gravity = ToastGravity.BOTTOM,
      Color backgroundColor = AppColors.CommonGreen}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: AppColors.Textstylecolor,
      fontSize: 16.0,
    );
  }
}
