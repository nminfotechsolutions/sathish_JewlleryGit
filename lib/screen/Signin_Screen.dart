import 'package:agni_chit_saving/constants/colors.dart';
import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/Forget_Password_Screen.dart';
import 'package:agni_chit_saving/screen/Main_menu.dart';
import 'package:agni_chit_saving/screen/Otp_screen.dart';
import 'package:agni_chit_saving/screen/Signup_screen.dart';
import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';
import 'package:agni_chit_saving/widget/CommonTextFieldWithBorder.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _EmailandphnController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();

  bool _validateMobNo = false;
  bool _validatePassword = false;
  bool isLoading = false;
  bool _IssecuredNew = true;

  Future<void> onRegisterPressed() async {
    String Mobno = _EmailandphnController.text;
    String pass = _PasswordController.text;

    setState(() {
      isLoading = true;
      _validateMobNo =
          commonUtils.validateTextField(_EmailandphnController, _validateMobNo);
      _validatePassword =
          commonUtils.validateTextField(_PasswordController, _validatePassword);
    });

    if (!_validateMobNo && !_validatePassword) {
      final SqlConnectionService sqlService = SqlConnectionService();
      String querry = '''
      select USERNAME,MOBILENO,EMAIL,PASS,CONPASS,USERID,ACTIVE from usermaster where 
       PASS='$pass' and MOBILENO='$Mobno'  
    ''';

      commonUtils.log.i("Fetch Data From Login Screen: $querry");

      dynamic results = await sqlService.fetchData(querry);

      if (results.isNotEmpty) {
        Map<String, dynamic> userData = results.first;
        String USERNAME = userData['USERNAME'];
        String MOBILENO = userData['MOBILENO'];
        String EMAIL = userData['EMAIL'];
        String PASS = userData['PASS'];
        String CONPASS = userData['CONPASS'];
        String USERID = userData['USERID'];
        String ACTIVE = userData['ACTIVE'];

        SharedPreferencesHelper.saveString('USERNAME', USERNAME);
        SharedPreferencesHelper.saveString('MOBILENO', MOBILENO);
        SharedPreferencesHelper.saveString('EMAIL', EMAIL);
        SharedPreferencesHelper.saveString('PASS', PASS);
        SharedPreferencesHelper.saveString('CONPASS', CONPASS);
        SharedPreferencesHelper.saveString('USERID', USERID);
        SharedPreferencesHelper.saveString('ACTIVE', ACTIVE);

        _EmailandphnController.text = "";
        _PasswordController.text = "";

        SharedPreferencesHelper.saveBool('isLoggedIn', true);

        /*Fluttertoast.showToast(msg: '$Prefs');*/
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CommonBottomnavigation()));
      } else {
        commonUtils.showToast('Invalid username or password',
            backgroundColor: AppColors.CommonRed);
        _EmailandphnController.text = "";
        _PasswordController.text = "";
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onchanged(String value) {
    String Mobno = _EmailandphnController.text;

    if (Mobno.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'The entered mobile number is more than 11 digit',
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var Heightscreen = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: SafeArea(
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 0,
            right: 0,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.yellowAccent, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Image.asset(
                "assets/images/top.png",
                width: 150,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/Companylogo.png",
                      height: 250,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Login',
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: Heightscreen * .03,
                    ),
                    CommonTextFieldWithBorder(
                      onChanged: _onchanged,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter Your Mobileno',
                      controller: _EmailandphnController,
                      labelText: 'Mobileno',
                      prefixIcon: Icons.person,
                      errorText: _validateMobNo
                          ? 'Mobile No Value Can\'t Be Empty'
                          : null,
                    ),
                    CommonTextFieldWithBorder(
                      suffixIcon: _IssecuredNew
                          ? Icons.visibility_off
                          : Icons.visibility,
                      suffixIconOnPressed: () {
                        setState(() {
                          _IssecuredNew = !_IssecuredNew;
                        });
                      },
                      hintText: 'Enter Your Password',
                      controller: _PasswordController,
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: _IssecuredNew,
                      errorText: _validatePassword
                          ? 'Password Value Can\'t Be Empty'
                          : null,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordScreen()));
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blue.shade900),
                            )),
                      ],
                    ),
                    RoundedElevatedButton(
                      onPressed: () async {
                        if (!isLoading) {
                          // Check if it's not already loading
                          await onRegisterPressed();
                        }
                      },
                      backgroundColor: Colors.amberAccent,
                      text: 'Login',
                      foregroundColor: Colors.black,
                      width: 200,
                      borderRadius: 15,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text('Login'),
                    ),
                    SizedBox(
                      height: Heightscreen * .04,
                    ),
                    const Divider(),
                    SizedBox(
                      height: Heightscreen * .04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Dont Have An Account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login_screen()));
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        )
                      ],
                    ),
                    Text(
                      'version 5.0',
                      style: commonTextStyleSmall(color: AppColors.CommonGrey),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
