import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/Forget_Password_Screen.dart';
import 'package:agni_chit_saving/screen/Main_menu.dart';
import 'package:agni_chit_saving/screen/Otp_screen.dart';
import 'package:agni_chit_saving/screen/Profile_Screen.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/screen/Signup_screen.dart';
import 'package:agni_chit_saving/screen/kyc_screen.dart';
import 'package:agni_chit_saving/screen/payment_gateway.dart';
import 'package:agni_chit_saving/screen/payment_ledger.dart';
import 'package:agni_chit_saving/screen/rewards.dart';
import 'package:agni_chit_saving/screen/My_Savings_Screen.dart';
import 'package:agni_chit_saving/screen/schemeLedger.dart';
import 'package:agni_chit_saving/screen/splash_screen.dart';
import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';

class AppRoutes {
  static const String otp = '/login_screen';
  static const String Signin = '/SigninScreen';
  static const String signup = '/login_screen';
  static const String splashscreens = '/SplashScreen';
  static const String Main_menus = '/Main_menu';
  static const String payment_gateways = '/payment_gateway';
  static const String savings_screen = '/savings';
  static const String rewars_screen = '/rewards';
  static const String CommonBottomnavigationScreen = '/CommonBottomnavigation';
  static const String ProfileScreens = '/ProfileScreen';
  static const String ChangepinScreens = '/ForgetPasswordScreen';
  static const String kycscreen = '/kyc_screen';
  static const String paymentledgers = '/payment_ledger';
  static const String schemeLedgers = '/schemeLedger';

  static Map<String, WidgetBuilder> Routes = {
    otp: (context) => const OtpScreen(previousPage: '',),
    Signin: (context) => const SigninScreen(),
    signup: (context) => const login_screen(),
    splashscreens: (context) => const SplashScreen(),
    Main_menus: (context) => const Main_menu(),
    savings_screen: (context) => const MySavingsScreen(),
    rewars_screen: (context) => const rewards(),
    ProfileScreens: (context) => ProfileScreen(),
    CommonBottomnavigationScreen: (context) => CommonBottomnavigation(),
    splashscreens: (context) => const SplashScreen(),
    ChangepinScreens: (context) => const ForgetPasswordScreen(),
    paymentledgers: (context) => const payment_ledger(),
    // schemeLedgers: (context) => const schemeLedger(),
  };
}
