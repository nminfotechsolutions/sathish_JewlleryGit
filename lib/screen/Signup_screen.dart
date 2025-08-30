import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/Otp_screen.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonTextFieldWithBorder.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/SqlConnectionService.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login_screen> {
  final TextEditingController _CustomernameController = TextEditingController();
  final TextEditingController _MobilenumberController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _ConfrimPassController = TextEditingController();

  bool _validateName = false;
  bool _validateMobNo = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _validateConfrimPassword = false;
  bool isLoading = false;

  bool _termsAccepted = false;

  Future<void> _sendOtp() async {
    commonUtils.otp = _generateOtp();

    String mobileNo = _MobilenumberController.text.trim();
    commonUtils.otp = _generateOtp();
    String baseUrl = "http://www.nminfotech.in/smsautosend.aspx";
    String id = "AGNISO";
    String password = "AGNISO";

    String template = "T";

    String message =
        "Dear Valued Customer, Your OTP  ${commonUtils.otp} For Saving Scheme is Valid till 120 Seconds. Thank You For Choosing Sathish Jewellery.";

    String encodedMessage = Uri.encodeComponent(message);

    String url =
        "$baseUrl?id=$id&PWD=$password&mob=$mobileNo&msg=$encodedMessage&tm=$template";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _CustomernameController.text = "";
        _MobilenumberController.text = "";
        _EmailController.text = "";
        _PasswordController.text = "";
        _ConfrimPassController.text = "";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                      previousPage: 'Signup',
                    )));
      } else {
        commonUtils.showToast('Failed to send OTP',
            backgroundColor: AppColors.CommonRed);
      }
    } catch (e) {
      commonUtils.showToast('An Error Occured',
          backgroundColor: AppColors.CommonRed);
    }
  }

  String _generateOtp() {
    const String chars = '0123456789';
    Random random = Random();
    String otp = '';
    while (otp.length < 4) {
      int index = random.nextInt(chars.length);
      otp += chars[index];
    }
    return otp;
  }

  Future<void> _onRegisterBtnPressed() async {
    setState(() {
      isLoading = true;
      _validateName =
          commonUtils.validateTextField(_CustomernameController, _validateName);
      _validateMobNo = commonUtils.validateTextField(
          _MobilenumberController, _validateMobNo);
      if (_EmailController.text.isEmpty) {
        _validateEmail = true;
      } else if (!_EmailController.text.contains('@')) {
        _validateEmail = true;
      } else {
        _validateEmail = false;
      }

      _validatePassword =
          commonUtils.validateTextField(_PasswordController, _validatePassword);
      _validateConfrimPassword = commonUtils.validateTextField(
          _ConfrimPassController, _validateConfrimPassword);
    });

    if (_validateName == false &&
        _validateMobNo == false &&
        _validateEmail == false &&
        _validatePassword == false &&
        _validateConfrimPassword == false) {
      if (_MobilenumberController.text.length != 10) {
        commonUtils.showToast('Mobile Number Must Be 10 Digit',
            backgroundColor: AppColors.CommonRed);
      } else {
        if (_PasswordController.text == _ConfrimPassController.text) {
          bool mobileExists =
              await checkMobileNumber(_MobilenumberController.text);
          bool EmailExists = await checkEmailid(_EmailController.text);

          if (mobileExists) {
            commonUtils.showToast("Already This Mobile No Created",
                backgroundColor: AppColors.CommonRed);
          } else if (EmailExists) {
            commonUtils.showToast("Already This Email Id Created",
                backgroundColor: AppColors.CommonRed);
          } else {
            commonUtils.userData = {
              'Customer Name': _CustomernameController.text,
              'Mobile Number': _MobilenumberController.text,
              'Email': _EmailController.text,
              'Password': _PasswordController.text,
              'Confirm Password': _ConfrimPassController.text,
            };

            commonUtils.log.i("User Data: ${commonUtils.userData}");

            bool emailExists = await checkEmailid(_EmailController.text);
            if (!emailExists) {
              await _sendOtp();
            } else {
              Fluttertoast.showToast(msg: "Email already exists");
            }
          }
        } else {
          Fluttertoast.showToast(msg: "Password mismatch");
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> checkMobileNumber(String mobileNO) async {
    final SqlConnectionService sqlService = SqlConnectionService();

    String query = '''
    select * from usermaster where mobileno = '$mobileNO'
  ''';
    commonUtils.log.i("Fetch Data From Login Screen: $query");

    dynamic results = await sqlService.fetchData(query);

    return results.isNotEmpty;
  }

  Future<bool> checkEmailid(String email) async {
    final SqlConnectionService sqlService = SqlConnectionService();

    String query = '''
    select * from usermaster where email = '$email'
  ''';
    commonUtils.log.i("Fetch Data From Login Screens: $query");

    dynamic results = await sqlService.fetchData(query);

    return results.isNotEmpty;
  }

  String Email = '';

  @override
  Widget build(BuildContext context) {
    var Heightscreen = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
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
                        "assets/images/login.png",
                        height: 200,
                      ),
                      Text(
                        'Create New Account',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: Heightscreen * .03,
                      ),
                      CommonTextFieldWithBorder(
                        hintText: 'CUSTOMER NAME',
                        controller: _CustomernameController,
                        labelText: 'CUSTOMER NAME',
                        prefixIcon: Icons.people,
                        labelStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 1,
                            color: Colors.black45),
                        errorText:
                            _validateName ? 'Name Value Can\'t Be Empty' : null,
                      ),
                      CommonTextFieldWithBorder(
                        keyboardType: TextInputType.number,
                        hintText: 'MOBILE NUMBER',
                        controller: _MobilenumberController,
                        labelText: 'MOBILE NUMBER',
                        maxlength: 10,
                        labelStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Colors.black45),
                        prefixIcon: Icons.phone,
                        errorText: _validateMobNo
                            ? 'Mobile No Value Can\'t Be Empty'
                            : null,
                      ),
                      CommonTextFieldWithBorder(
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'EMAIL',
                        controller: _EmailController,
                        labelText: 'EMAIL',
                        prefixIcon: Icons.email,
                        labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          color: Colors.black45,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                        errorText: _validateEmail
                            ? 'Email Value Can\'t Be Empty'
                            : null,
                      ),
                      CommonTextFieldWithBorder(
                        hintText: 'PASSWORD',
                        labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          color: Colors.black45,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                        controller: _PasswordController,
                        labelText: 'PASSWORD',
                        prefixIcon: Icons.lock,
                        errorText: _validatePassword
                            ? 'Password Value Can\'t Be Empty'
                            : null,
                      ),
                      CommonTextFieldWithBorder(
                        hintText: 'CONFIRM PASSWORD',
                        controller: _ConfrimPassController,
                        labelText: 'CONFIRM PASSWORD',
                        prefixIcon: Icons.lock,
                        labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          color: Colors.black45,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                        errorText: _validateConfrimPassword
                            ? 'Confirm Password Value Can\'t Be Empty'
                            : null,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                        title: Text("By Registering T & C Change",
                            style: commonTextStyleMedium(
                                color: AppColors.CommonColor)),
                        value: _termsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAccepted = value!;
                          });
                          // Fluttertoast.showToast(msg:"CheckBox Is Tested");
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedElevatedButton(
                        onPressed: () async {
                          if (_termsAccepted) {
                            _onRegisterBtnPressed();
                          } else {
                            commonUtils.showToast(
                                "Please Accept Registering T & C",
                                backgroundColor: AppColors.CommonRed);
                          }
                        },
                        backgroundColor: Colors.amberAccent,
                        text: 'Register',
                        foregroundColor: Colors.black,
                        width: 200,
                        borderRadius: 15,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text('Register'),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Do You Have Account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SigninScreen()));
                              },
                              child: Text('Sign in',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1)))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
