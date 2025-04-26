import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/widget/CommonTextFieldWithBorder.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:flutter/material.dart';

class ChangepinScreen extends StatefulWidget {
  const ChangepinScreen({super.key});

  @override
  State<ChangepinScreen> createState() => _ChangepinScreenState();
}

class _ChangepinScreenState extends State<ChangepinScreen> {
  TextEditingController Mpincontroller = TextEditingController();
  TextEditingController ConfrimMpincontroller = TextEditingController();

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
                  height: 280,
                ),
              ),
              const Text(
                'Reset MPIN',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    letterSpacing: 1),
              ),
              const Text('Please Enter Your 4 Digit Pin'),
              SizedBox(
                height: Heightscreen * .04,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CommonTextFieldWithBorder(
                      hintText: 'Enter Your MPIN',
                      controller: Mpincontroller,
                      labelText: 'YOUR MPIN',
                      labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Colors.black45),
                      prefixIcon: Icons.lock,
                    ),
                    SizedBox(
                      height: Heightscreen * .03,
                    ),
                    CommonTextFieldWithBorder(
                      hintText: 'Enter Confrim MPIN',
                      controller: ConfrimMpincontroller,
                      labelText: 'CONFRIM MPIN',
                      labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Colors.black45),
                      prefixIcon: Icons.lock,
                    ),
                    SizedBox(
                      height: Heightscreen * .04,
                    ),
                    RoundedElevatedButton(
                      onPressed: () {},
                      text: 'Reset Pin',
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                      width: 200,
                      borderRadius: 15,
                    )
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
