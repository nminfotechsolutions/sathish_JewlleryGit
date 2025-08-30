import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/Otp_screen.dart';
import 'package:agni_chit_saving/widget/CommonTextFieldWithBorder.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _MobilenumberController = TextEditingController();
  bool _validateMobNo = false;
  bool isLoading = false;
  String OTP = commonUtils.otp;
  Future<void> _sendOtp() async {
    // otpController.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? CustomerName =
        prefs.getString('USERNAME'); // Retrieve customer name
    String mobileNo = commonUtils.userData['Mobile Number'] ?? '';
    commonUtils.log.i(CustomerName);
    setState(() {
      OTP = _generateOtp();
    });
    // 'http://bulksms.agnisofterp.com/api/smsapi?key=f4c3e6001753ec62c906f4bab4ad73df&route=2&sender=SMSTRT&number=$mobileNo&sms=Dear valued Customer Your Service Code $OTP For savings scheme. Thanks for choosing AGNISOFT. For Any Support Call - +91 9159152272 -SMSTRT&templateid=1607100000000328064';

    commonUtils.log.i("Your OTP is ${OTP}");
    String baseUrl =
        'https://pay4sms.in/sendsms/?token=9d70b9201ddeb8ff8228f468a23d424e&credit=2&sender=SATJEW&message=Dear Customer, your one time SATHISH JEWELLERY DigiGold password $OTP Sathish THANGANAGAI MALIGAI is Authentication Valid upto 3 minutes..&number=$mobileNo&templateid=1707175385913746578';

    commonUtils.log.i("Your baseUrl is ${baseUrl}");
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          commonUtils.forgetMobNo = _MobilenumberController.text;
        });
        _MobilenumberController.text = "";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                      previousPage: 'ForgetPassword',
                    )));
      } else {}
    } catch (e) {}
  }
/*  Future<void> _sendOtp() async {
    String mobileNo = _MobilenumberController.text.trim();
    commonUtils.otp = _generateOtp();
    String baseUrl = "http://www.nminfotech.in/smsautosend.aspx";
    String id = "AGNISO";
    String password = "AGNISO";
    String message =
        "Dear Valued Customer, Your OTP  ${commonUtils.otp} For Saving Scheme is Valid till 120 Seconds. Thank You For Choosing Sathish Jewellery.";
    String template = "T";

    String encodedMessage = Uri.encodeComponent(message);

    String url =
        "$baseUrl?id=$id&PWD=$password&mob=$mobileNo&msg=$encodedMessage&tm=$template";

    commonUtils.log.i(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          commonUtils.forgetMobNo = _MobilenumberController.text;
        });
        _MobilenumberController.text = "";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                      previousPage: 'ForgetPassword',
                    )));
      } else {
        commonUtils.showToast('Failed to send OTP',
            backgroundColor: AppColors.CommonRed);
      }
    } catch (e) {
      commonUtils.showToast('An Error Occured',
          backgroundColor: AppColors.CommonRed);
    }
  }*/

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

  Future<void> _OnForgetpassword() async {
    String Mobile = _MobilenumberController.text;
    final SqlConnectionService sqlService = SqlConnectionService();

    setState(() {
      isLoading = true;
      _validateMobNo = commonUtils.validateTextField(
          _MobilenumberController, _validateMobNo);
    });

    if (!_validateMobNo) {
      String querry =
          """ select * from usermaster where mobileno = '$Mobile'""";

      dynamic results = await sqlService.fetchData(querry);

      commonUtils.log.i('Forgot Password is $querry ');
      if (results.isNotEmpty) {
        SharedPreferencesHelper.saveString('MOBILENO', Mobile);
        commonUtils.userData = {
          'Mobile Number': _MobilenumberController.text,
        };
        await _sendOtp();
      } else if (_MobilenumberController.text.length != 10) {
        commonUtils.showToast('Mobile Number Must Be 10 Digit',
            backgroundColor: AppColors.CommonRed);
      } else {
        commonUtils.showToast('Invalid Mobile Number',
            backgroundColor: AppColors.CommonRed);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var Heightscreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/changepin.png',
                  fit: BoxFit.fill,
                  height: 250,
                ),
              ),
              Text(
                'Forgot Password',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    letterSpacing: 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Please Enter Your Registered Mobile Number \n to recieve OTP',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.grey[400], fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Heightscreen * .04,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    CommonTextFieldWithBorder(
                      hintText: 'Enter Your Mobile Number',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.black45),
                      keyboardType: TextInputType.number,
                      controller: _MobilenumberController,
                      labelText: 'Mobile Number',
                      labelStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                      errorText: _validateMobNo
                          ? 'Mobile No Value Can\'t Be Empty'
                          : null,
                      prefixIcon: Icons.phone,
                      maxlength: 10,
                    ),
                    SizedBox(
                      height: Heightscreen * .05,
                    ),
                    RoundedElevatedButton(
                      onPressed: () async {
                        if (!isLoading) {
                          // Check if it's not already loading
                          await _OnForgetpassword();
                        }
                      },
                      backgroundColor: Colors.amberAccent,
                      text: 'Submit',
                      foregroundColor: Colors.black,
                      width: 200,
                      borderRadius: 15,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text('Submit'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
