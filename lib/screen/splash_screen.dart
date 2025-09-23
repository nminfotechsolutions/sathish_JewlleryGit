// import 'package:agni_chit_saving/constants/colors.dart';
// import 'package:agni_chit_saving/modal/MdlCompanyData.dart';
// import 'package:agni_chit_saving/modal/MdlNewScheme.dart';
// import 'package:agni_chit_saving/screen/Main_menu.dart';
// import 'package:agni_chit_saving/screen/Signin_Screen.dart';
// import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Routes/App_Routes.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToMainScreen();
//     MdlNewScheme.fecthdatafromNewScheme();
//     MdlCompanyData.fecthdatafromQuery();
//   }
//
//   Future<void> _navigateToMainScreen() async {
//     await Future.delayed(const Duration(seconds: 4));
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (isLoggedIn) {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => CommonBottomnavigation()));
//       /*Navigator.pushReplacementNamed(context, AppRoutes.  );*/
//     } else {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => SigninScreen()));
//       /* Navigator.pushReplacementNamed(context, AppRoutes.);*/
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.network(
//             'https://www.bneedsbill.com/flutterimg/agnisoftimg/splash.jpg',
//             fit: BoxFit.cover,
//           ),
//           // Image.asset(
//           //   'assets/images/splash.jpg',
//           //   fit: BoxFit.cover,
//           // ),
//           const SizedBox(height: 0.0),
//           const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFbd6031)),
//               strokeWidth: 5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:agni_chit_saving/constants/colors.dart';
import 'package:agni_chit_saving/modal/MdlCompanyData.dart';
import 'package:agni_chit_saving/modal/MdlNewScheme.dart';
import 'package:agni_chit_saving/screen/Main_menu.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Routes/App_Routes.dart';
import 'package:agni_chit_saving/database/SqlConnectionService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String currentVersion = "1";

  final SqlConnectionService sqlService = SqlConnectionService();
  @override
  void initState() {
    super.initState();
    _checkVersionAndNavigate();
    MdlNewScheme.fecthdatafromNewScheme();
    MdlCompanyData.fecthdatafromQuery();
  }

  Future<void> _checkVersionAndNavigate() async {
    try {

      String query = "EXEC [VER_CHK] '1'";
      final result = await sqlService.fetchData(query);

      print("Raw result from stored procedure: $result");

      if (result != null && result.isNotEmpty) {
        // Print the first row
        print("First row of result: ${result[0]}");

        // Assuming your SP returns something like { "RESULT": 1 }
        final checkValue = result[0]['VER_IS'].toString();
        print("Check value: $checkValue");

        if (checkValue == "1") {
          print("Version OK → navigating to main screen");
          _navigateToMainScreen();
        } else {
          print("Version outdated → showing update bottom sheet");
          _showUpdateBottomSheet();
        }
      } else {
        print("No data returned → showing update bottom sheet");
        _showUpdateBottomSheet();
      }
    } catch (e) {
      print("Error checking version: $e");
      _showUpdateBottomSheet();
    }
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CommonBottomnavigation()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SigninScreen()));
    }
  }

  void _showUpdateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: double.infinity,
          height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/splash.jpg',
                height: 100,
              ),
              const SizedBox(height: 15),
              const Text(
                "A new version of the app is available.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {

                  StoreRedirect.redirect(
                    androidAppId:
                        "com.sathish.sathishjewellery", // Your Play Store package
                    // iOSAppId: "YOUR_IOS_APP_ID", // Optional for App Store
                  );
                },
                child: const Text("UPDATE NOW"),
              ),

            ],
          ),
        );
      },
    );
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
