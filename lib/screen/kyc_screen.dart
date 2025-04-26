import 'dart:io';
import 'package:agni_chit_saving/modal/MdlNewScheme.dart';
import 'package:agni_chit_saving/modal/MdlProfileScreen.dart';
import 'package:agni_chit_saving/screen/Calculation_Screen.dart';
import 'package:agni_chit_saving/widget/CommonTextFieldWithBorder.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../routes/app_export.dart';
import 'payment_gateway.dart';

class kyc_screen extends StatefulWidget {
  final String schemeType;
  final String amount;
  final bool readonly;

  kyc_screen({
    required this.schemeType,
    required this.amount,
    required this.readonly,
  });
  @override
  _Kyc_screenState createState() => _Kyc_screenState();
}

class _Kyc_screenState extends State<kyc_screen> {
  MdlNewScheme? album;
  List<Map<String, dynamic>>? albumList;

  bool _isEditAdd = false;
  bool _isEditNomineeDet = false;
  bool _isEditProof = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _add1Controller = TextEditingController();
  final TextEditingController _add2Controller = TextEditingController();
  final TextEditingController _add3Controller = TextEditingController();
  final TextEditingController _panNoController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _nomNameController = TextEditingController();
  final TextEditingController _nomMobnoController = TextEditingController();

  String conPass = "";
  String pass = "";
  String userid = "";
  String active = "";
  String imgPath = "";
  String schemeType = "";

  final picker = ImagePicker();
  File? image;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _add1Controller.dispose();
    _add2Controller.dispose();
    _add3Controller.dispose();
    _panNoController.dispose();
    _aadharController.dispose();
    _nomNameController.dispose();
    _nomMobnoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Uint8List? imageBytes;

  Future<List<MdlProfileScreen>> _fetchProfileScreen() async {
    try {
      return MdlProfileScreen.fecthProfileScreenquerry();
    } catch (e) {
      commonUtils.log.i('Error fetching item data: $e');
      return [];
    }
  }

  void _toggleEditing(String section) {
    setState(() {
      if (section == 'address') {
        _isEditAdd = !_isEditAdd;
        if (_isEditAdd) FocusScope.of(context).requestFocus(_focusNode);
      } else if (section == 'nominee') {
        _isEditNomineeDet = !_isEditNomineeDet;
        if (_isEditNomineeDet) FocusScope.of(context).requestFocus(_focusNode);
      } else if (section == 'proof') {
        _isEditProof = !_isEditProof;
        if (_isEditProof) FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  Future<void> save() async {
    String name = _nameController.text;
    String mobno = _mobileController.text;
    String email = _emailController.text;
    String aadharno = _aadharController.text;
    String panno = _panNoController.text;
    String add1 = _add1Controller.text;
    String add2 = _add2Controller.text;
    String add3 = _add3Controller.text;
    String nomname = _nomNameController.text;
    String nommobno = _nomMobnoController.text;

    List<MdlProfileScreen> profilescreenlist = [
      MdlProfileScreen(
        USERNAME: name,
        MOBILENO: mobno,
        EMAIL: email,
        PASS: pass,
        CONPASS: conPass,
        USERID: userid,
        ACTIVE: active,
        Imgpath: imgPath,
        ADD1: add1,
        ADD2: add2,
        ADD3: add3,
        NOM_NAME: nomname,
        NOM_MOBNO: nommobno,
        AADHARNO: aadharno,
        PANNO: panno,
      ),
    ];
    SharedPreferencesHelper.saveString('USERNAME', name);
    SharedPreferencesHelper.saveString('MOBILENO', mobno);
    SharedPreferencesHelper.saveString('EMAIL', email);
    SharedPreferencesHelper.saveString('AADHARNO', aadharno);
    SharedPreferencesHelper.saveString('PANNO', panno);
    SharedPreferencesHelper.saveString('ADD1', add1);
    SharedPreferencesHelper.saveString('ADD2', add2);
    SharedPreferencesHelper.saveString('ADD3', add3);
    SharedPreferencesHelper.saveString('NOMNAME', nomname);
    SharedPreferencesHelper.saveString('NOMMOBNO', nommobno);

    await MdlProfileScreen.updateDataFromServer(profilescreenlist);
/*    Fluttertoast.showToast(msg: "Profile Update Successfully");
    Navigator.pushReplacementNamed(
        context, AppRoutes.CommonBottomnavigationScreen);*/
  }

  Future<void> _onSavedPressedForCompanyProfile() async {
    try {
      save();
    } catch (e) {
      commonUtils.log.e("Error: $e");
    }
  }

  Future<void> _initializeProfileData() async {
    MdlProfileScreen.futureMdlProfileScreen = _fetchProfileScreen();
    MdlProfileScreen.futureMdlProfileScreen.then((profileData) {
      if (profileData.isNotEmpty) {
        setState(() {
          _nameController.text = profileData[0].USERNAME;
          _mobileController.text = profileData[0].MOBILENO;
          _emailController.text = profileData[0].EMAIL;
          _add1Controller.text = profileData[0].ADD1;
          _add2Controller.text = profileData[0].ADD2;
          _add3Controller.text = profileData[0].ADD3;
          _panNoController.text = profileData[0].PANNO;
          _aadharController.text = profileData[0].AADHARNO;
          _nomNameController.text = profileData[0].NOM_NAME;
          _nomMobnoController.text = profileData[0].NOM_MOBNO;
          pass = profileData[0].PASS;
          conPass = profileData[0].CONPASS;
          userid = profileData[0].USERID;
          active = profileData[0].ACTIVE;
          imgPath = profileData[0].Imgpath;
        });
      }
    });
    _focusNode = FocusNode();
    await _retrieveData();
  }

  Future<void> _retrieveData() async {
    String? albumJson = SharedPreferencesHelper.getString('MdlNewScheme');
    commonUtils.log.i("I am From Kyc Reterive Data :$albumJson");
    if (albumJson != null && albumJson.isNotEmpty) {
      commonUtils.log.i(albumJson);
      Map<String, dynamic> albumMap = jsonDecode(albumJson);
      setState(() {
        albumList = [albumMap];
      });

      if (albumList!.isNotEmpty) {
        final album = albumList![0];
        setState(() {
          schemeType = album['schemeType'] ?? '';
        });
        commonUtils.log.i("schemeType == $schemeType ");
      }
    }
    // Fluttertoast.showToast(msg: "$schemeType");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/Pbackground.png')),
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade400, Colors.white70],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 50),
                              Text(
                                "Scheme Joining Form",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Kindly Provide the following KYC details \n Please ensure details match your ID proof \n Fields marked * are mandatory",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          color: AppColors.Textstylecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Basic Details",
                                        style: commonTextStyleLarge(
                                            color: AppColors.CommonColor)),
                                  ],
                                ),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Name",
                                  labelText: "Name *",
                                  controller: _nameController,
                                  showBorder: false,
                                  readOnly: true),
                              CommonTextFieldWithBorder(
                                  showBorder: false,
                                  labelText: "Mobile Number",
                                  hintText: "Mobile Number *",
                                  controller: _mobileController,
                                  readOnly: true),
                              CommonTextFieldWithBorder(
                                  hintText: "Email",
                                  labelText: "Email *",
                                  showBorder: false,
                                  controller: _emailController,
                                  readOnly: true),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 15,
                          color: AppColors.Textstylecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Address",
                                        style: commonTextStyleLarge(
                                            color: AppColors.CommonColor)),
                                    IconButton(
                                      onPressed: () {
                                        _toggleEditing('address');
                                      },
                                      icon: Icon(
                                        _isEditAdd ? Icons.save : Icons.edit,
                                        size: 20,
                                        color: AppColors.CommonBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Address 1",
                                  labelText: "Address 1",
                                  controller: _add1Controller,
                                  showBorder: _isEditAdd,
                                  readOnly: !_isEditAdd),
                              CommonTextFieldWithBorder(
                                  hintText: "Address 2",
                                  labelText: "Address 2",
                                  controller: _add2Controller,
                                  showBorder: _isEditAdd,
                                  readOnly: !_isEditAdd),
                              CommonTextFieldWithBorder(
                                  hintText: "Address 3",
                                  labelText: "Address 3",
                                  controller: _add3Controller,
                                  showBorder: _isEditAdd,
                                  readOnly: !_isEditAdd),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 15,
                          color: AppColors.Textstylecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Nominee Details",
                                        style: commonTextStyleLarge(
                                            color: AppColors.CommonColor)),
                                    IconButton(
                                      onPressed: () {
                                        _toggleEditing('nominee');
                                      },
                                      icon: Icon(
                                        _isEditNomineeDet
                                            ? Icons.save
                                            : Icons.edit,
                                        size: 20,
                                        color: AppColors.CommonBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Nominee Name",
                                  labelText: "Nominee Name",
                                  controller: _nomNameController,
                                  showBorder: _isEditNomineeDet,
                                  readOnly: !_isEditNomineeDet),
                              CommonTextFieldWithBorder(
                                  hintText: "Nominee Mobile Number",
                                  labelText: "Nominee Mobile Number",
                                  controller: _nomMobnoController,
                                  readOnly: !_isEditNomineeDet,
                                  showBorder: _isEditNomineeDet,
                                  keyboardType: TextInputType.number),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 15,
                          color: AppColors.Textstylecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Proof",
                                        style: commonTextStyleLarge(
                                            color: AppColors.CommonColor)),
                                    IconButton(
                                      onPressed: () {
                                        _toggleEditing('proof');
                                      },
                                      icon: Icon(
                                        _isEditProof ? Icons.save : Icons.edit,
                                        size: 20,
                                        color: AppColors.CommonBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Aadhaar Number",
                                  labelText: "Aadhaar Number",
                                  showBorder: _isEditProof,
                                  controller: _aadharController,
                                  readOnly: !_isEditProof,
                                  keyboardType: TextInputType.number),
                              CommonTextFieldWithBorder(
                                  hintText: "Pan Number",
                                  labelText: "Pan Number",
                                  controller: _panNoController,
                                  showBorder: _isEditProof,
                                  readOnly: !_isEditProof),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue.shade900),
                ),
                onPressed: () async {
                  await _onSavedPressedForCompanyProfile();
                  if (schemeType == "AMOUNT") {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            payment_gateway(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  } else {
                    SharedPreferencesHelper.removeKey("MdlMysavingsScheme");
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CalculationScreen(
                          readonly: widget.readonly,
                          amount: widget.amount,
                          Accno: '',
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                },
                child: Text(
                  'CONFIRM',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
