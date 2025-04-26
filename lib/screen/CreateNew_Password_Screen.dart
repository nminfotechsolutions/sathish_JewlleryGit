import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/Main_menu.dart';
import 'package:agni_chit_saving/screen/Otp_screen.dart';
import 'package:agni_chit_saving/screen/Signin_Screen.dart';
import 'package:agni_chit_saving/widget/CommonBottomnavigation.dart';
import 'package:flutter/material.dart';

class CreatenewPasswordScreen extends StatefulWidget {
  const CreatenewPasswordScreen({super.key});

  @override
  State<CreatenewPasswordScreen> createState() =>
      _CreatenewPasswordScreenState();
}

class _CreatenewPasswordScreenState extends State<CreatenewPasswordScreen> {
  TextEditingController _NewPasswordController = TextEditingController();
  TextEditingController _ConfrimPasswordController = TextEditingController();
  bool _Issecured = true;
  bool _IssecuredNew = true;
  bool isLoading = false;
  bool _validateConfirmPassword = false;
  bool _validatePassword = false;

  Future<void> _Onupdate() async {
    String Newpassword = _NewPasswordController.text;
    String ConPass = _ConfrimPasswordController.text;
    String Mobileno = SharedPreferencesHelper.getString('MOBILENO');

    if(Newpassword == ConPass) {
      setState(() {
        isLoading = true;
        _validatePassword =
            commonUtils.validateTextField(
                _NewPasswordController, _validatePassword);
        _validateConfirmPassword =
            commonUtils.validateTextField(
                _ConfrimPasswordController, _validateConfirmPassword);
      });
      final SqlConnectionService service = SqlConnectionService();

      String querry = """
    update  usermaster set Pass = '$Newpassword'  ,conpass = '$ConPass' where mobileno = '$Mobileno'
     """;

      if (_NewPasswordController.text != "" &&
          _ConfrimPasswordController.text != "" &&
          _NewPasswordController.text == _ConfrimPasswordController.text) {
        dynamic results = await service.writeData(querry);
        commonUtils.log.i(results);
        SharedPreferencesHelper.saveBool('isLoggedIn', true);
        SharedPreferencesHelper.saveString('PASS', Newpassword);
        SharedPreferencesHelper.saveString('CONPASS', ConPass);

        commonUtils.showToast('Password Updated');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SigninScreen()));
      } else {
        commonUtils.showToast('Password Mismacth', backgroundColor: Colors.red);
      }
      setState(() {
        isLoading = false;
      });
    }
    else{
      commonUtils.showToast("Password Didnot Match",backgroundColor: Colors.red);
      _NewPasswordController.text="";
      _ConfrimPasswordController.text="";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        /*  leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpScreen(
                              previousPage: '',
                            )));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ))*/
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Password',
                      style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Set a Strong password to keep secure your\naccount',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'New Password',
                  style: GoogleFonts.lato(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextFieldWithBorder(
                    suffixIcon:
                        _IssecuredNew ? Icons.visibility_off : Icons.visibility,
                    suffixIconOnPressed: () {
                      setState(() {
                        _IssecuredNew = !_IssecuredNew;
                      });
                    },
                    hintText: 'Enter a new password',
                    obscureText: _IssecuredNew,
                    errorText: _validatePassword
                        ? 'Password Value Can\'t Be Empty'
                        : null,
                    hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                    controller: _NewPasswordController),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Confirm Password',
                  style: GoogleFonts.lato(
                      fontSize: 17,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextFieldWithBorder(
                    suffixIcon:
                        _Issecured ? Icons.visibility_off : Icons.visibility,
                    obscureText: _Issecured,
                    suffixIconOnPressed: () {
                      setState(() {
                        _Issecured = !_Issecured;
                      });
                    },
                    hintText: 'Confrim your new password',
                    errorText: _validatePassword
                        ? 'Confirm Password Value Can\'t Be Empty'
                        : null,
                    hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                    controller: _ConfrimPasswordController),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child:   RoundedElevatedButton(
                    onPressed: () async {
                      if (!isLoading) {
                        // Check if it's not already loading
                        await _Onupdate();
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
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
