import 'package:agni_chit_saving/modal/MdlCompanyData.dart';
import 'package:agni_chit_saving/modal/MdlJoiningNewScheme.dart';
import 'package:agni_chit_saving/modal/MdlNewScheme.dart';
import 'package:agni_chit_saving/modal/Mdl_MySavings_Scheme.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/payment_gateway.dart';
import 'package:agni_chit_saving/widget/CommonTextSize.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:flutter/material.dart';

class CalculationScreen extends StatefulWidget {
  final String amount;
  final String Accno;
  final bool? readonly;

  CalculationScreen({
    required this.amount,
    required this.Accno,
    this.readonly,
  });
  @override
  State<CalculationScreen> createState() => _CalculationScreenScreenState();
}

class _CalculationScreenScreenState extends State<CalculationScreen> {
  final TextEditingController _weightController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  MdlNewScheme? album;
  List<Map<String, dynamic>>? albumList;
  String companyName = '';
  String? username;
  String? mobno;
  String? email;
  String? aadharno;
  String? panno;
  String? add1;
  String? add2;
  String? add3;
  String? nomname;
  String? nommobno;
  String? schemeName;
  String? NoOfInstall;
  String? AmtPerMonth;
  String? CurrentDate;
  String? Razor_key;
  String? goldRate;
  String? silverRate;
  String? schemeType;
  String? enteredAmount;
  String? enterWeight;
  String? customerId;
  String? todayRate;

  @override
  void initState() {
    super.initState();
    getPrefsData();
    _calculateWeight();
    _amountController = TextEditingController(text: widget.amount.toString());

    // Fluttertoast.showToast(msg: "I am In Calculation Screen");
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> getPrefsData() async {
    username = SharedPreferencesHelper.getString('USERNAME');
    mobno = SharedPreferencesHelper.getString('MOBILENO');
    todayRate = SharedPreferencesHelper.getString('TODAYRATE');
    email = SharedPreferencesHelper.getString('EMAIL');
    aadharno = SharedPreferencesHelper.getString('AADHARNO');
    panno = SharedPreferencesHelper.getString('PANNO');
    add1 = SharedPreferencesHelper.getString('ADD1');
    add2 = SharedPreferencesHelper.getString('ADD3');
    add3 = SharedPreferencesHelper.getString('ADD3');
    nomname = SharedPreferencesHelper.getString('NOMNAME');
    nommobno = SharedPreferencesHelper.getString('NOMMOBNO');
    goldRate = SharedPreferencesHelper.getString('GOLD');
    companyName = SharedPreferencesHelper.getString('company_name');

    // silverRate = SharedPreferencesHelper.getString('SILVER');
    //

    // schemeName = widget.album.schemeName;
    // NoOfInstall = widget.album.noIns;
    // AmtPerMonth = widget.album.amount; vc
    // CurrentDate = commonUtils.formatDate(commonUtils.selectedDate);
    //
    // await _initializeCompanyData();

    await _retrieveData();
  }

  // Future<void> _retrieveData() async {
  //   String? albumJson = SharedPreferencesHelper.getString('MdlNewScheme');
  //   if (albumJson != null) {
  //     setState(() {
  //       album = MdlNewScheme.fromJson(jsonDecode(albumJson));
  //     });
  //     customerId = album!.groupCode + album!.regNo;
  //   }
  //   else{
  //     String? albumJson = SharedPreferencesHelper.getString('MdlMysavingsScheme');
  //     setState(() {
  //       album = MdlNewScheme.fromJson(jsonDecode(albumJson));
  //     });
  //     customerId = album!.groupCode + album!.regNo;
  //
  //   }
  // }

  Future<void> _retrieveData() async {
    try {
      String? albumJson = SharedPreferencesHelper.getString('MdlNewScheme');
      if (albumJson != null && albumJson.isNotEmpty) {
        Map<String, dynamic> albumMap = jsonDecode(albumJson);
        setState(() {
          albumList = [albumMap]; // Wrap the map in a list
        });
        if (albumList!.isNotEmpty) {
          customerId = (albumList![0]['groupCode'] ?? '') +
              (albumList![0]['regNo'] ?? '');

          // Fluttertoast.showToast(msg: "$customerId");
        }
        // Fluttertoast.showToast(msg: "I am in MdlNewScheme");
      } else {
        albumJson = SharedPreferencesHelper.getString('MdlMysavingsScheme');
        if (albumJson != null && albumJson.isNotEmpty) {
          Map<String, dynamic> albumMap = jsonDecode(albumJson);
          setState(() {
            albumList = [albumMap]; // Wrap the map in a list
          });
          if (albumList!.isNotEmpty) {
            customerId = (albumList![0]['groupCode'] ?? '') +
                (albumList![0]['regNo'] ?? '');
          }
        } else {
          Fluttertoast.showToast(msg: "I am in MdlSavingScheme");
        }
      }
    } catch (e) {
      commonUtils.log.i("Error: $e");
    }
  }

  void _calculateWeight() {
    double enterAmount =
        double.tryParse(widget.amount) ?? 0.0; // Get the passed amount
    double todayGoldRate = double.parse(goldRate!);
    double grams = enterAmount / todayGoldRate;

    setState(() {
      _weightController.text = grams.toStringAsFixed(3); // Update weight field
    });
  }

  void onAmountEntered(String text) {
    double EnterAmount = double.parse(_amountController.text);
    double TodayGodRate = double.parse(goldRate!);
    double grams = EnterAmount / TodayGodRate;
    _weightController.text = grams.toStringAsFixed(3);
  }

  Future<void> saveNewScheme() async {
    try {
      String? userid = SharedPreferencesHelper.getString("USERID");

      if (userid == null) {
        commonUtils.log.i("Error: USERID is null");
        return;
      }

      // Validate albumList and its first item
      if (albumList == null || albumList!.isEmpty) {
        commonUtils.log.i("Error: albumList is null or empty");
        return;
      }

      final album = albumList![0];

      commonUtils.log.i(album);

      String chitId = album['chitId'] ?? '';
      String schName = album['schemeName'] ?? '';
      String amount = album['schemeAmount'] ?? '';
      String schAmt =
          album['schemeType'] == 'WEIGHT' ? (enteredAmount ?? amount) : amount;
      String schCode = album['SCHCODE'] ?? '';
      String noIns = album['noIns'] ?? '';
      String totalMembers = album['totalMembers'] ?? '';
      String regNo = album['regNo'] ?? '';
      String active = album['active'] ?? '';
      String schemeId = album['schemeId'] ?? '';
      String branchId = album['branchId'] ?? '';
      String metId = album['metId'] ?? '';
      String groupcode = album['groupCode'] ?? '';
      String schemeType = album['schemeType'] ?? '';
      String schemeno = album['SCHEMENO'] ?? '';

      String pgrswt = _weightController.text;
      String pnetwt = '1';
      String pamount = _amountController.text;

      List<MdlJoiningNewScheme> SavingSchemeList = [
        MdlJoiningNewScheme(
          vouNo: '',
          jid: commonUtils.formatDateWithYMD(commonUtils.selectedDate) ?? '',
          schName: schName,
          schCode: schemeId,
          SCHEMENO: schemeno,
          schAmt: pamount,
          regNo: regNo,
          name: username ?? '',
          add1: add1 ?? '',
          add2: add2 ?? '',
          add3: add3 ?? '',
          city: '',
          state: '',
          country: '',
          mobNo: mobno ?? '',
          cash: '0.0',
          card: pamount,
          cardName: 'CHITAPP',
          cardNo: '',
          cardAmt: '',
          cheque: '',
          chequeNo: '',
          chequeDate: '',
          chequeAmt: '',
          mobTran: '',
          billNo: '',
          billDate:
              commonUtils.formatDateWithYMD(commonUtils.selectedDate) ?? '',
          closeDate: '',
          accNo: '',
          flag: 'R',
          cancel: 'N',
          branchId: branchId,
          metId: metId,
          metval: goldRate?.toString() ?? '0.0',
          closeBillNo: '',
          time: '',
          goldRate: goldRate?.toString() ?? '0.0',
          silverRate: silverRate?.toString() ?? '0.0',
          lock: '',
          remarks: '',
          nomIni: nomname ?? '',
          adharNo: aadharno ?? '',
          rod: commonUtils.formatDateWithYMD(commonUtils.selectedDate) ?? '',
          chitId: chitId,
          schemeId: schemeId,
          userId: userid,
          groupcode: groupcode,
          pgrswt: pgrswt,
          pnetwt: pnetwt,
          pamount: pamount,
          REFNO: '',
        ),
      ];

      await MdlJoiningNewScheme.updateDataFromServerForPayNow(SavingSchemeList);
      Navigator.pop(context, true);
      Navigator.pushReplacementNamed(
          context, AppRoutes.CommonBottomnavigationScreen);
      // commonUtils.log.i(schName);
      // commonUtils.log.i(schCode);
      // commonUtils.log.i(branchId);
    } catch (e) {
      commonUtils.log.i("Error: $e");
    }
  }

  Future<void> onPayNowPressed() async {
    String? albumJson = SharedPreferencesHelper.getString('MdlNewScheme') ?? '';

    // if (albumJson != null && albumJson.isNotEmpty) {
    // Fluttertoast.showToast(msg: "Saving Scheme");
    await storeData();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            payment_gateway(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
    // } else {
    //   saveNewScheme();
    // }
  }

  Future<void> storeData() async {
    await SharedPreferencesHelper.saveString(
        'NewSchemeEnterAmount', _amountController.text);
    await SharedPreferencesHelper.saveString(
        'NewSchemeEnterweight', _weightController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.amber.shade300, Colors.white70],
            ),
          ),
        ),
        title: Text(
          '$companyName',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PAY INTO : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      Text(
                        username!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PASSBOOK: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      Text(
                        widget.Accno ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/goldcoin.gif'),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'GOLD RATE\n22KT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    todayRate!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Rs : ${goldRate}',
                              style: Commontextsize.CommonLargeSize(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w900),
                          onChanged: (text) => onAmountEntered(text),
                          controller: _amountController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelStyle: TextStyle(fontSize: 15),
                            labelText: 'Amount(₹)',
                          ),
                          readOnly: widget.readonly ?? false,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w900),
                          readOnly: true,
                          controller: _weightController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Weight',
                              labelStyle: TextStyle(fontSize: 15)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RoundedElevatedButton(
                        onPressed: () {},
                        backgroundColor: Colors.deepPurple,
                        text: 'CANCEL',
                        foregroundColor: Colors.white,
                        width: 100,
                        borderRadius: 15,
                      ),
                      RoundedElevatedButton(
                        onPressed: () async {
                          await onPayNowPressed();
                        },
                        backgroundColor: Colors.deepPurple,
                        text: 'Pay Now',
                        foregroundColor: Colors.white,
                        width: 100,
                        borderRadius: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
