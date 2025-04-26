import 'package:agni_chit_saving/constants/colors.dart';
import 'package:agni_chit_saving/modal/MdlCompanyData.dart';
import 'package:agni_chit_saving/modal/MdlNewScheme.dart';
import 'package:agni_chit_saving/screen/Main_menu.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Routes/App_Routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
    MdlNewScheme.fecthdatafromNewScheme();
    MdlCompanyData.fecthdatafromQuery();
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CommonBottomnavigation()));
      /*Navigator.pushReplacementNamed(context, AppRoutes.  );*/
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SigninScreen()));
      /* Navigator.pushReplacementNamed(context, AppRoutes.);*/
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://www.bneedsbill.com/flutterimg/agnisoftimg/splash.jpg',
            fit: BoxFit.cover,
          ),
          // Image.asset(
          //   'assets/images/splash.jpg',
          //   fit: BoxFit.cover,
          // ),
          const SizedBox(height: 0.0),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFbd6031)),
              strokeWidth: 5,
            ),
          ),
        ],
      ),
    );
  }
}
