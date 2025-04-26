import 'package:marquee/marquee.dart';
import 'package:agni_chit_saving/constants/variables.dart';
import 'package:agni_chit_saving/modal/MdlCompanyData.dart';
import 'package:agni_chit_saving/modal/MdlJoiningNewScheme.dart';
import 'package:agni_chit_saving/modal/MdlRateFecthing.dart';
import 'package:agni_chit_saving/modal/Mdl_MySavings_Scheme.dart';
import 'package:agni_chit_saving/modal/RazorPayService.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/screen/Calculation_Screen.dart';
import 'package:agni_chit_saving/screen/schemeLedger.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonDrawer.dart';
import 'package:agni_chit_saving/widget/CommonShimmer.dart';
import 'package:agni_chit_saving/widget/CommonTextSize.dart';
import 'package:agni_chit_saving/widget/RoundedElevatedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MySavingsScreen extends StatefulWidget {
  const MySavingsScreen({Key? key});

  @override
  State<MySavingsScreen> createState() => _MySavingsScreenState();
}

class _MySavingsScreenState extends State<MySavingsScreen> {
  String Companyname = '';
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
  String? EndDate;
  String? Razor_key;
  String? goldRate;
  String? silverRate;
  String? schemeType;
  String? enteredAmount;
  String? enterWeight;
  String? transactionId;
  String? status;
  List<MdlMysavingsScheme> _schemes = [];
  late RazorPayService _razorPayService;
  late Future<List<MdlCompanyData>> futureMdlCompanyData;
  String? companyName = '';
  late Future<List<MdlMysavingsScheme>> FutureMySavings = Future.value([]);

  String _formatDate(String date) {
    try {
      DateTime parsedDate =
          DateTime.parse(date); // Parse the string to DateTime
      return DateFormat("dd-MM-yyyy")
          .format(parsedDate); // Format as DD-MM-YYYY
    } catch (e) {
      return date; // If parsing fails, return original string
    }
  }

  @override
  void initState() {
    super.initState();
    initialData();
    Companyname = SharedPreferencesHelper.getString('company_name') ?? '';
  }

  @override
  void dispose() {
    _razorPayService.dispose();
    super.dispose();
  }

  Future<List<MdlCompanyData>> _fetchCompanyData() async {
    try {
      return MdlCompanyData.fecthdatafromQuery();
    } catch (e) {
      commonUtils.log.i('Error fetching item data: $e');
      return [];
    }
  }

  Future<void> initialData() async {
    try {
      FutureMySavings = _fetchNewSchemeData();
      await _initializeCompanyData();
      _razorPayService = RazorPayService(context);
      refreshAlbums();
    } catch (e) {
      print('Error fetching item data: $e');
    }
  }

  Future<void> _initializeCompanyData() async {
    futureMdlCompanyData = _fetchCompanyData();

    futureMdlCompanyData.then((companyDataList) async {
      if (companyDataList.isNotEmpty) {
        // Print each item in the list
        for (var companyData in companyDataList) {
          print("Company Name: ${companyData.companyname}");
          print("Company ID: ${companyData.companyid}");
        }

        setState(() {
          companyName = companyDataList[0].companyname ?? '';
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('company_name', companyName!);
      }
    }).catchError((error) {
      commonUtils.log.i('Error ${error}');
    });
  }

  Future<void> _printSchemeDetails(List<MdlMysavingsScheme> schemes) async {
    for (var scheme in schemes) {
      print('Scheme Name: ${scheme.NAME}');
      print('Scheme Details: ${scheme.PAIDINS}');
      // Add more fields if necessary
      print('---');
    }
  }

  Future<List<MdlMysavingsScheme>> _fetchNewSchemeData() async {
    try {
      return MdlMysavingsScheme.fetchDataFromSavings();
    } catch (e) {
      print('Error fetching item data: $e');
      return [];
    }
  }

  Future<void> refreshAlbums() async {
    try {
      List<MdlRateMaster> result = await MdlRateMaster.fecthdatafromrate();
      setState(() {
        MdlRateMaster.Ratemaster = result;
        MdlRateMaster.GoldRate = MdlRateMaster.Ratemaster.isNotEmpty
            ? MdlRateMaster.Ratemaster[0].GOLD
            : "0.00";
        MdlRateMaster.SilverRate = MdlRateMaster.Ratemaster.isNotEmpty
            ? MdlRateMaster.Ratemaster[0].SILVER
            : "0.00";
        Companyname = SharedPreferencesHelper.getString('company_name') ?? '';
      });
    } catch (e) {
      commonUtils.log.i("Error In main Menu Refresh Album ${e}");
    }
  }

  Future<void> getPrefsData() async {
    try {
      username = SharedPreferencesHelper.getString('USERNAME') ?? '';
      mobno = SharedPreferencesHelper.getString('MOBILENO') ?? '';
      email = SharedPreferencesHelper.getString('EMAIL') ?? '';
      aadharno = SharedPreferencesHelper.getString('AADHARNO') ?? '';
      panno = SharedPreferencesHelper.getString('PANNO') ?? '';
      add1 = SharedPreferencesHelper.getString('ADD1') ?? '';
      add2 = SharedPreferencesHelper.getString('ADD2') ?? '';
      add3 = SharedPreferencesHelper.getString('ADD3') ?? '';
      nomname = SharedPreferencesHelper.getString('NOMNAME') ?? '';
      nommobno = SharedPreferencesHelper.getString('NOMMOBNO') ?? '';
      goldRate = SharedPreferencesHelper.getString('GOLD') ?? '';
      silverRate = SharedPreferencesHelper.getString('SILVER') ?? '';
      enteredAmount =
          SharedPreferencesHelper.getString('NewSchemeEnterAmount') ?? '';
      enterWeight =
          SharedPreferencesHelper.getString('NewSchemeEnterweight') ?? '';
    } catch (e, stackTrace) {
      commonUtils.log.i("Error: $e");
      commonUtils.log.i("Stack Trace: $stackTrace");
    }
  }

  Future<void> saveNewScheme({required MdlMysavingsScheme album}) async {
    if (album.SCHEMETYPE == "AMOUNT") {
      await _razorPayService.initializePayment(
        amount: album.SCHAMT,
        contact: '',
        email: '',
      );
      String userid = SharedPreferencesHelper.getString("USERID");
      // Fluttertoast.showToast(msg: "${album.GROUPCODE}");
      List<MdlJoiningNewScheme> NewSchemeList = [
        MdlJoiningNewScheme(
          vouNo: '',
          jid: '',
          schName: album.SCHNAME,
          SCHEMENO: album.SCHEMENO,
          schCode: album.SCHCODE,
          schAmt: album.SCHAMT,
          regNo: album.REGNO,
          name: '',
          add1: '',
          add2: '',
          add3: '',
          city: '',
          state: '',
          country: '',
          mobNo: '',
          cash: '0.00',
          card: album.SCHAMT,
          cardName: 'CHITAPP',
          cardNo: '',
          cardAmt: '',
          cheque: '',
          chequeNo: '',
          chequeDate: '',
          chequeAmt: '',
          mobTran: '',
          billNo: '',
          billDate: '',
          closeDate: '',
          accNo: '',
          flag: 'R',
          cancel: 'N',
          branchId: album.BRANCHID,
          metId: album.METID,
          metval: MdlRateMaster.GoldRate.toString(),
          closeBillNo: '',
          time: '',
          goldRate: MdlRateMaster.GoldRate.toString(),
          silverRate: MdlRateMaster.SilverRate.toString(),
          lock: '',
          remarks: '',
          nomIni: '',
          adharNo: '',
          rod: commonUtils.formatDateWithYMD(commonUtils.selectedDate),
          chitId: album.CHITID,
          schemeId: album.SCHEMEID,
          userId: userid,
          groupcode: album.GROUPCODE,
          pgrswt: '0.00',
          pnetwt: '0.00',
          pamount: '0.00',
          REFNO: '',
        ),
      ];
      await MdlJoiningNewScheme.updateDataFromServerForPayNow(NewSchemeList);
      // Fluttertoast.showToast(msg: "Successfully Paided");
      Navigator.pushReplacementNamed(
          context, AppRoutes.CommonBottomnavigationScreen);
    } else {
      SharedPreferencesHelper.saveString("SchemeMethod", "MySavingScheme");
      await storeData(album);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CalculationScreen(
            amount: album.SCHAMT,
            Accno: album.ACCNO,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> storeData(MdlMysavingsScheme album) async {
    SharedPreferencesHelper.removeKey("MdlNewScheme");
    String albumJson = jsonEncode(album.toJson());
    SharedPreferencesHelper.saveString("MdlMysavingsScheme", albumJson);
    commonUtils.log.i('Saved album JSON: $albumJson');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var Heightscreen = MediaQuery.of(context).size.height;
    var Weightscreen = MediaQuery.of(context).size.width;
    return Scaffold(

      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image.network(
                'https://www.bneedsbill.com/flutterimg/agnisoftimg/Companylogo.png',
                height: 40,
              ),
              Text(
                Companyname,
                style: const TextStyle(
                  color: Color(0XFF953130),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const commonDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshAlbums,
          child: Column(
            children: [
              Container(
                height: 60,
                color: const Color(0XFF953130),
                child: Marquee(
                  text:
                      "GOLD RATE: ₹ ${MdlRateMaster.GoldRate}  |   SILVER RATE: ₹ ${MdlRateMaster.SilverRate} | RATE UPDATED ON : ${_formatDate(MdlRateMaster.date)},",
                  style: const TextStyle(
                    color: Colors.yellow, // Text color
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 50.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10,
                  accelerationDuration: const Duration(seconds: 1),
                  decelerationDuration: const Duration(seconds: 2),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: FutureMySavings,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.all(7.0),
                            child: ShimmerEffect(
                                height: 150, width: double.infinity),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      List<MdlMysavingsScheme> allNewSchemeData =
                          snapshot.data!;
                      List<MdlMysavingsScheme> filteredMdlNewScheme = [];
                      if (allNewSchemeData.isEmpty &&
                          filteredMdlNewScheme.isEmpty) {
                        return const Center(
                          child: Text(
                            'No savings available',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredMdlNewScheme.isEmpty
                            ? allNewSchemeData.length
                            : filteredMdlNewScheme.length,
                        itemBuilder: (context, index) {
                          MdlMysavingsScheme album =
                              filteredMdlNewScheme.isEmpty
                                  ? allNewSchemeData[index]
                                  : filteredMdlNewScheme[index];

                          String balanceLabel;
                          String displayValue;
                          if (album.GROUPCODE == 'GGK-AMT') {
                            balanceLabel = 'Balance';
                            displayValue = album.BALANCE;
                          } else if (album.GROUPCODE == 'GGK-WT') {
                            balanceLabel = 'Total Weight';
                            displayValue = album.TOTALWGT;
                          } else {
                            balanceLabel = 'Balance';
                            displayValue = album.BALANCE;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(
                              color: Colors.lightBlue,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.amber.shade300,
                                      Colors.white,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/body11.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            companyName ?? '',
                                                            style: GoogleFonts.lato(
                                                                color: Colors
                                                                    .grey
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Name: ",
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(),
                                                              ),
                                                              Text(
                                                                album.NAME,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            album.ACCNO,
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            textAlign:
                                                                TextAlign.right,
                                                            album.STATUS,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: album.STATUS ==
                                                                      'BILLED'
                                                                  ? Colors.red
                                                                  : album.STATUS ==
                                                                          'ACTIVE'
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey
                                                                          .shade800,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Heightscreen * .01,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "Total Paid",
                                                          style: Commontextsize
                                                              .CommonMediumSize(),
                                                        ),
                                                        Text(
                                                          textAlign:
                                                              TextAlign.right,
                                                          album.PAID,
                                                          style: Commontextsize
                                                              .CommonMediumSize(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade900),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "Maturity Date",
                                                          style: Commontextsize
                                                              .CommonMediumSize(),
                                                        ),
                                                        Text(
                                                          textAlign:
                                                              TextAlign.right,
                                                          _formatDate(album
                                                              .MATURITY_DATE), // Format the date here
                                                          style: Commontextsize
                                                              .CommonMediumSize(),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    RoundedElevatedButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          CommonVariables
                                                                  .SchemeLedger =
                                                              album.REGNO;
                                                          CommonVariables
                                                                  .schemeno =
                                                              album.SCHCODE;
                                                        });
                                                        commonUtils.log.i(
                                                            CommonVariables
                                                                .SchemeLedger);
                                                        commonUtils.log.i(
                                                            CommonVariables
                                                                .schemeno);
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) =>
                                                                schemeLedger(
                                                              installment:
                                                                  album.NOINS,
                                                              customerName:
                                                                  album.NAME,
                                                              schemeType: album
                                                                  .SCHEMETYPE,
                                                              accNo:
                                                                  album.ACCNO,
                                                              Weight: album
                                                                  .TOTALWGT,
                                                            ),
                                                            transitionsBuilder:
                                                                (context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                              return FadeTransition(
                                                                opacity:
                                                                    animation,
                                                                child: child,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      text: 'Scheme Ledger',
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: album.PAIDINS,
                                                            style: Commontextsize
                                                                .CommonLargeSize(),
                                                          ),
                                                          WidgetSpan(
                                                            child: Text(
                                                              '/',
                                                              style: Commontextsize
                                                                  .CommonLargeSize(),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: album.NOINS,
                                                            style: Commontextsize
                                                                .CommonLargeSize(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color:
                                                                Colors.green),
                                                        child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              await saveNewScheme(
                                                                  album: album);
                                                            },
                                                            child: const Text(
                                                              'Pay Now',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No data available.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
