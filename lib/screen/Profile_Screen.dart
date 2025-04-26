import 'dart:io';
import 'package:agni_chit_saving/modal/MdlProfileScreen.dart';
import 'package:agni_chit_saving/utils/Image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<MdlProfileScreen>> futureMdlProfileScreen;
  List<MdlProfileScreen> allMdlProfileScreen = [];
  List<MdlProfileScreen> filteredMdlProfileScreen = [];

  bool _isEditing = true;
  bool _showBorder = false;

  bool _validateName = false;
  bool _validateMobno = false;
  bool _validateEmail = false;

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

  final picker = ImagePicker();
  File? image;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    _focusNode = FocusNode();
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

  final ImagePicker _picker = ImagePicker();

  Future<void> selectImage() async {
    Uint8List? img = await _pickImage();
    if (img != null) {
      String filePath = await _saveImageToLocalDirectory(img);
      setState(() {
        imageBytes = img;
        imgPath = filePath;
      });
      await _saveImagePathToPreferences(filePath);
      commonUtils.log.i("Image saved at: $filePath");
    }
  }

  Future<Uint8List?> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }
    return null;
  }

  Future<String> _saveImageToLocalDirectory(Uint8List imageBytes) async {
    String? username = SharedPreferencesHelper.getString("USERNAME");
    final directory = await getApplicationDocumentsDirectory();
    String fileName = '$username.png';
    final file = File(path.join(directory.path, fileName));
    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  Future<void> _saveImagePathToPreferences(String filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', filePath);
  }

  Future<void> _loadProfileImage(String imgPath) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();*/
    String? filePath = imgPath.toString();
    if (filePath != null) {
      setState(() {
        imgPath = filePath;
      });
      imageBytes = await File(filePath).readAsBytes();
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      _showBorder = !_showBorder;
    });
    FocusScope.of(context).requestFocus(_focusNode);
  }

  Future<void> save() async {
    setState(() {
      _validateName =
          commonUtils.validateTextField(_mobileController, _validateName);
      _validateMobno =
          commonUtils.validateTextField(_mobileController, _validateMobno);
      _validateEmail =
          commonUtils.validateTextField(_emailController, _validateEmail);
    });

    if (!_validateName && !_validateMobno && !_validateEmail) {
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
      String ImagePath =
          SharedPreferencesHelper.getString("profile_image_path");

      List<MdlProfileScreen> profilescreenlist = [
        MdlProfileScreen(
          USERNAME: name,
          MOBILENO: mobno,
          EMAIL: email,
          PASS: pass,
          CONPASS: conPass,
          USERID: userid,
          ACTIVE: active,
          Imgpath: ImagePath,
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
      commonUtils.showToast("Profile Update Successfully",
          backgroundColor: AppColors.CommonGreen);
      Navigator.pushReplacementNamed(
          context, AppRoutes.CommonBottomnavigationScreen);
    }
  }

  Future<void> _onSavedPressed() async {
    try {
      CommonDialog.show(
        context: context,
        title: 'Confirmation',
        onYes: () {
          save();
        },
      );
    } catch (e) {
      commonUtils.log.e("Error: $e");
    }
  }

  Future<void> _initializeProfileData() async {
    futureMdlProfileScreen = _fetchProfileScreen();
    futureMdlProfileScreen.then((profileData) async {
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

        await _loadProfileImage(imgPath);
      }
    });
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
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: imageBytes != null
                                ? MemoryImage(imageBytes!)
                                : const AssetImage('assets/images/profile.png')
                                    as ImageProvider,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: AppColors.Textstylecolor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 180),
              child: ListView(
                children: [
                  Column(
                    children: [
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
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("PERSONAL DETAILS",
                                        style: commonTextStyleSmall(
                                            color: AppColors.CommonColor)),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_isEditing) {
                                            _toggleEditing();
                                          } else {
                                            _onSavedPressed();
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        _isEditing ? Icons.edit : Icons.save,
                                        size: 20,
                                        color: AppColors.CommonBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                hintText: "Name",
                                labelText: "Name *",
                                controller: _nameController,
                                showBorder: _showBorder,
                                focusNode: _focusNode,
                                readOnly: _isEditing,
                                errorText: _validateName
                                    ? 'Name Value Can\'t Be Empty'
                                    : null,
                              ),
                              CommonTextFieldWithBorder(
                                  showBorder: _showBorder,
                                  labelText: "Mobile Number",
                                  hintText: "Mobile Number *",
                                  controller: _mobileController,
                                  errorText: _validateMobno
                                      ? 'Mob No Value Can\'t Be Empty'
                                      : null,
                                  readOnly: _isEditing),
                              CommonTextFieldWithBorder(
                                  hintText: "Email",
                                  labelText: "Email *",
                                  showBorder: _showBorder,
                                  controller: _emailController,
                                  errorText: _validateEmail
                                      ? 'Email Value Can\'t Be Empty'
                                      : null,
                                  readOnly: _isEditing),
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
                                padding: const EdgeInsets.all(12.0),
                                child: Text("PROOF",
                                    style: commonTextStyleSmall(
                                        color: AppColors.CommonColor)),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Aadhaar Number",
                                  labelText: "Aadhaar Number",
                                  showBorder: _showBorder,
                                  controller: _aadharController,
                                  readOnly: _isEditing,
                                  keyboardType: TextInputType.number),
                              CommonTextFieldWithBorder(
                                  hintText: "Pan Number",
                                  labelText: "Pan Number",
                                  controller: _panNoController,
                                  showBorder: _showBorder,
                                  readOnly: _isEditing),
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
                                padding: const EdgeInsets.all(12.0),
                                child: Text("ADDRESS",
                                    style: commonTextStyleSmall(
                                        color: AppColors.CommonColor)),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Address 1",
                                  labelText: "Address 1",
                                  controller: _add1Controller,
                                  showBorder: _showBorder,
                                  readOnly: _isEditing),
                              CommonTextFieldWithBorder(
                                  hintText: "Address 2",
                                  labelText: "Address 2",
                                  controller: _add2Controller,
                                  showBorder: _showBorder,
                                  readOnly: _isEditing),
                              CommonTextFieldWithBorder(
                                  hintText: "Address 3",
                                  labelText: "Address 3",
                                  controller: _add3Controller,
                                  showBorder: _showBorder,
                                  readOnly: _isEditing),
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
                                padding: const EdgeInsets.all(12.0),
                                child: Text("NOMINEE DETAILS",
                                    style: commonTextStyleSmall(
                                        color: AppColors.CommonColor)),
                              ),
                              const Divider(),
                              CommonTextFieldWithBorder(
                                  hintText: "Nominee Name",
                                  labelText: "Nominee Name",
                                  controller: _nomNameController,
                                  showBorder: _showBorder,
                                  readOnly: _isEditing),
                              CommonTextFieldWithBorder(
                                  hintText: "Nominee Mobile Number *",
                                  labelText: "Nominee Mobile Number *",
                                  controller: _nomMobnoController,
                                  readOnly: _isEditing,
                                  showBorder: _showBorder,
                                  keyboardType: TextInputType.number),
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
      ),
    );
  }
}
