import 'dart:async';

import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/CreateNew_Password_Screen.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  final String previousPage;
  const OtpScreen({super.key, required this.previousPage});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpFieldController? otpController;

  late Timer _timer;
  int _start = 50; // 30 seconds countdown
  String OTP = commonUtils.otp;
  String EnterOtp = "";

  String MobileNo = "";

  @override
  void initState() {
    super.initState();
    otpController = OtpFieldController(); // Initialize here

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _sendOtp();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> _onVerifyClick() async {
    if (widget.previousPage == 'Signup') {
      if (OTP == EnterOtp) {
        final SqlConnectionService sqlService = SqlConnectionService();
        String customerName = commonUtils.userData['Customer Name'] ?? '';
        String mobileNumber = commonUtils.userData['Mobile Number'] ?? '';
        String email = commonUtils.userData['Email'] ?? '';
        String password = commonUtils.userData['Password'] ?? '';
        String confirmPassword = commonUtils.userData['Confirm Password'] ?? '';

        String query = '''
          Declare @Userid varchar(5)
        select @Userid =  convert(varchar(12),Isnull(max(convert(int,Userid)) ,'0') + 1) from Usermaster
      INSERT INTO USERMASTER (USERNAME,MOBILENO,EMAIL,PASS,CONPASS,USERID,ACTIVE)
      VALUES ('$customerName', '$mobileNumber', '$email','$password','$confirmPassword',@Userid,'Y');
    ''';
        commonUtils.log.i(query);
        String? result = await sqlService.writeData(query);
        if (result != null) {
          commonUtils.userData.clear();
          // otpController.clear();
          SharedPreferencesHelper.saveString('USERNAME', customerName);
          SharedPreferencesHelper.saveString('MOBILENO', mobileNumber);
          SharedPreferencesHelper.saveString('EMAIL', email);
          commonUtils.log.i('Data insert successfully in server: $result');
          commonUtils.showToast('Account Created Successfully',
              backgroundColor: AppColors.CommonGreen);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SigninScreen()));
        } else {
          commonUtils.log
              .e('Failed to insert data for item with id ${customerName}');
        }
      } else {
        commonUtils.showToast('Enter Valid OTP Pin',
            backgroundColor: AppColors.CommonRed);
      }
    } else if (widget.previousPage == 'ForgetPassword') {
      if (OTP == EnterOtp) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreatenewPasswordScreen()));
      } else {
        // otpController.clear();
        commonUtils.showToast("Enter Valid OTP", backgroundColor: Colors.red);
      }
    }
  }

  void onResendCodeTap() {
    _sendOtp();
  }

  Future<void> _sendOtp() async {
    // otpController.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String mobileNo = commonUtils.userData['Mobile Number'] ?? '';
    String CustomerName = commonUtils.userData['Customer Name'] ?? '';
    commonUtils.log.i(CustomerName);
    setState(() {
      OTP = _generateOtp();
    });
    // 'http://bulksms.agnisofterp.com/api/smsapi?key=f4c3e6001753ec62c906f4bab4ad73df&route=2&sender=SMSTRT&number=$mobileNo&sms=Dear valued Customer Your Service Code $OTP For savings scheme. Thanks for choosing AGNISOFT. For Any Support Call - +91 9159152272 -SMSTRT&templateid=1607100000000328064';

    commonUtils.log.i("Your OTP is ${OTP}");
    String baseUrl =
        'http://pay4sms.in/sendsms/?token=9d70b9201ddeb8ff8228f468a23d424e&credit=2&sender=SATJEW&message=Dear $CustomerName Your OTP for SATHISH JEWELLERY DigiGold Registration is $OTP Thank You for Choosing Sathish Thanga Nagai Maligai.&number=$mobileNo&templateid=1707174046630778688';

    // String baseUrl =
    //     'https://webhooks.wappblaster.com/webhook/66fce4e576f37bade3f6ad4c?number=$mobileNo&message=microotp~$OTP';
    commonUtils.log.i("Your baseUrl is ${baseUrl}");
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        _showAlert(context, 'Please Check Your Phone and Enter Otp');
      } else {
        _showAlert(context, 'Failed to send OTP');
      }
    } catch (e) {
      _showAlert(context, 'An error occurred');
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

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var hightscreen = MediaQuery.of(context).size.height;
    var Widthscreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/lock.png',
                fit: BoxFit.fill,
                height: 280,
              ),
              const Text(
                'OTP VERFICATION',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
              // Text(
              //   commonUtils.otp,
              //   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              // ),
              SizedBox(
                height: hightscreen * .02,
              ),
              const Text(
                'We have send The OTP on \n Your Registered Mobile Number',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 18),
                  SizedBox(width: 5),
                  Text(
                    commonUtils.forgetMobNo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Your OTP Will Expire in (00:${_start.toString().padLeft(2, '0')})',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: hightscreen * .04,
              ),
              Center(
                child: OTPTextField(
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 15,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w900),
                    onChanged: (pin) {
                      commonUtils.log.i("Changed: " + pin);
                      EnterOtp = pin;
                    },
                    onCompleted: (pin) {
                      commonUtils.log.i("Completed: " + pin);
                      EnterOtp = pin;
                    }),
              ),
              SizedBox(
                height: hightscreen * .02,
              ),
              TextButton(
                  onPressed: () {
                    onResendCodeTap();
                  },
                  child: Text("Resend Code")),
              SizedBox(
                height: hightscreen * .02,
              ),
              RoundedElevatedButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: () {
                  _onVerifyClick();
                },
                width: Widthscreen * .6,
                borderRadius: 15,
                text: 'Verify',
                foregroundColor: Colors.black,
                backgroundColor: Colors.amberAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
