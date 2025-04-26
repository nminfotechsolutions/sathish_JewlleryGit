import 'package:agni_chit_saving/database/SqlConnectionService.dart';
import 'package:agni_chit_saving/modal/MdlCompanyData.dart';
import 'package:agni_chit_saving/modal/MdlJoiningNewScheme.dart';
import 'package:agni_chit_saving/modal/MdlNewScheme.dart';
import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:agni_chit_saving/utils/commonUtils.dart';
import 'package:agni_chit_saving/widget/CommonTextSize.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;

class payment_gateway extends StatefulWidget {
  @override
  State<payment_gateway> createState() => _payment_gatewayState();
}

class _payment_gatewayState extends State<payment_gateway> {
// sambath sir key this test Mode
  // key_id,key_secret
  // rzp_test_4QXEpvReNPfzd9,7n29FL6ICF1Zf9FQ75BWHmpT

  // Sathish Jewellery
  // key_id,key_secret
  // rzp_live_hLjGzcUXk1M9tP,ozB11BaY7kfe7A9TvsFajqN4

  late Future<List<MdlCompanyData>> futureMdlCompanyData;
  List<MdlCompanyData> allMdlCompanyData = [];
  List<MdlCompanyData> filteredMdlCompanyData = [];
  MdlNewScheme? album;
  List<Map<String, dynamic>>? albumList;
  DateTime? maturityDate;
  DateTime? currentDate;
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
  String? orderId;
  String? status;
  double amount = 0.0;
  String? accNo;
  @override
  void initState() {
    super.initState();
    getPrefsData();
    _loadAccNo();
    // GetCurrentDate();
    CurrentDate = commonUtils.formatDate(commonUtils.selectedDate) ?? 'N/A';
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

      //commonUtils.log.i("$username $mobno $email $aadharno $panno $add1 $add2 $add3 $nomname $nommobno $goldRate $silverRate $enteredAmount $enterWeight");

      await _retrieveData();

      // String? albumJson = SharedPreferencesHelper.getString('MdlNewScheme');
      // if (albumJson != null) {
      //   setState(() {
      //     album = MdlNewScheme.fromJson(jsonDecode(albumJson));
      //   });
      //   schemeName = album!.schemeName;
      //   NoOfInstall = album!.noIns;
      //   AmtPerMonth = album!.amount;
      //   schemeType = album!.schemeType;
      // }

      // Fluttertoast.showToast(msg: '$CurrentDate');

      await _initializeRazorKeyData();
      await calDatMaturity();
    } catch (e, stackTrace) {
      commonUtils.log.i("Error: $e");
      commonUtils.log.i("Stack Trace: $stackTrace");
    }
  }

  Future<List<MdlCompanyData>> _fetchCompanyData() async {
    try {
      return MdlCompanyData.fecthdatafromQuery();
    } catch (e) {
      commonUtils.log.i('Error fetching item data: $e');
      return [];
    }
  }

  void OnPayPressed() {
    if (maturityDate != null && maturityDate!.isBefore(DateTime.now())) {
      commonUtils
          .showToast('Maturity Date has expired! You cannot pay anymore.');
      return;
    } else {
      razorPay();
    }

    // saveNewScheme();
  }

  Future<String> createRazorpayOrder(double amount) async {
    var url = Uri.parse('https://api.razorpay.com/v1/orders');
    String apiKey = 'rzp_live_hLjGzcUXk1M9tP';
    String apiSecret = 'ozB11BaY7kfe7A9TvsFajqN4';

    // Prepare headers for basic auth
    var headers = {
      'Authorization':
          'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret'))
    };
    // String receiptId = generateReceiptId();
    // Prepare body for the order
    var body = jsonEncode({
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'payment_capture': 1
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String orderId = responseData['id'];
        return orderId; // Return the order id
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> razorPay() async {
    Razorpay razorpay = Razorpay();

    if (enteredAmount != null && enteredAmount.toString().isNotEmpty) {
      amount = double.tryParse(enteredAmount.toString()) ?? 0.0;
    } else if (AmtPerMonth != null && AmtPerMonth.toString().isNotEmpty) {
      amount = double.tryParse(AmtPerMonth.toString()) ?? 0.0;
    }

    try {
      String orderId = await createRazorpayOrder(amount); // Create the order
      var options = {
        'key': 'rzp_live_hLjGzcUXk1M9tP',
        'amount': (amount * 100).toInt(),
        'name': username,
        'description': 'Gold Chits',
        'order_id': orderId,
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {'contact': mobno, 'email': email},
        'external': {
          'wallets': ['paytm']
        }
      };

      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    } catch (e) {
      print('Error creating Razorpay order: $e');
    }
  }

  // String generateReceiptId() {
  //   DateTime now = DateTime.now();
  //   String datePart = "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}";
  //   int randomNumber = DateTime.now().microsecond % 10000; // Simple random part
  //   String runningPart = randomNumber.toString().padLeft(4, '0');
  //   return "REC-$datePart-$runningPart";
  // }
  //
  // String _twoDigits(int n) {
  //   return n.toString().padLeft(2, '0');
  // }

  Future<void> saveNewScheme() async {
    String? userid = SharedPreferencesHelper.getString("USERID");
    if (userid == null) {
      commonUtils.log.i("Error: USERID is null");
      return;
    }

    if (albumList == null || albumList!.isEmpty) {
      commonUtils.log.i("Error: albumList is null or empty");
      return;
    }
    try {
      final album = albumList![0];

      //
      // commonUtils.log.i(album);
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

      String pgrswt = schemeType == 'WEIGHT' ? (enterWeight ?? '0.00') : '0.00';
      String pnetwt = schemeType == 'WEIGHT' ? '1.00' : '0.00';
      String pamount =
          schemeType == 'WEIGHT' ? (enteredAmount ?? '0.00') : '0.00';

      List<MdlJoiningNewScheme> NewSchemeList = [
        MdlJoiningNewScheme(
          vouNo: '',
          jid: commonUtils.formatDateWithYMD(commonUtils.selectedDate) ?? '',
          schName: schName,
          schCode: schemeId,
          SCHEMENO: schemeno,
          schAmt: schAmt,
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
          card: schAmt,
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
          branchId: branchId,
          metId: '1',
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

      await MdlJoiningNewScheme.updateDataFromServer(
          NewSchemeList, transactionId!, status!);
      // await MdlJoiningNewScheme.updateDataFromServer(NewSchemeList, '1', 'D');
      Navigator.pop(context, true);
      Navigator.pushReplacementNamed(
          context, AppRoutes.CommonBottomnavigationScreen);
      commonUtils.log.i('transactionId=${transactionId}and status = ${status}');
      commonUtils.log.i(schCode);
      commonUtils.log.i(branchId);
    } catch (e) {
      commonUtils.log.i("Errors: $e");
    }
  }

  Future<void> handlePaymentErrorResponse(
      PaymentFailureResponse response) async {
    transactionId = response.error.toString();
    status = "Error";
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // await saveNewScheme();
    // await sendPaymentSuccessSMS(
    //     transactionId!); // Send SMS after payment success
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  // Future<void> handlePaymentSuccessResponse(
  //     PaymentSuccessResponse response) async {
  //   transactionId = response.paymentId;
  //   status = "Success";
  //   /*
  //   * Payment Success Response contains three values:
  //   * 1. Order ID
  //   * 2. Payment ID
  //   * 3. Signature
  //   * */
  //   commonUtils.log.i(response.data.toString());
  //   showAlertDialog(
  //       context, "Payment Successful", "Payment ID: ${response.paymentId}");
  //   await sendPaymentSuccessSMS(transactionId); // Send SMS after payment success
  //   Fluttertoast.showToast(
  //       msg: "Payment Successful!\nTransaction ID: $transactionId");
  //   print("Payment Success - Transaction ID: $transactionId");
  //   await saveNewScheme();
  // }

  Future<void> handlePaymentSuccessResponse(
      PaymentSuccessResponse response) async {
    transactionId = response.paymentId;
    orderId = response.orderId;
    status = "Success";

    commonUtils.log.i(response.data.toString());
    commonUtils.log.i('Order Id = $orderId');
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");

    Fluttertoast.showToast(
        msg: "Payment Successful!\nTransaction ID: $transactionId");
    print("Payment Success - Transaction ID: $transactionId");

    await sendPaymentSuccessSMS(transactionId!);
    await saveNewScheme();
  }

  Future<void> handleExternalWalletSelected(
      ExternalWalletResponse response) async {
    transactionId = response.walletName;
    status = "Wallet";
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
    await saveNewScheme();
  }

  Future<void> sendPaymentSuccessSMS(String transactionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerName = prefs.getString('USERNAME');

    // String? ACCNOO = prefs.getString('accnso');
    // commonUtils.log.i('Retrieved accno: $ACCNOO');
    commonUtils.log.i(customerName);
    commonUtils.log.i(mobno);
    commonUtils.log.i(accNo);

    if (customerName != null && customerName.isNotEmpty) {
      String message =
          'http://pay4sms.in/sendsms/?token=9d70b9201ddeb8ff8228f468a23d424e&credit=2&sender=SATJEW&message=அன்பான வாடிக்கையாளர்களே UPI user $customerName debited by $amount trf to சதீஷ் ஜுவல்லரி Refno: $transactionId தங்கள் வருகைக்கு நன்றி சதீஷ் தங்க நகை மாளிகை&number=9566633755&templateid=1707174048352596410';

      String smsApiUrl =
          "http://pay4sms.in/sendsms/?token=9d70b9201ddeb8ff8228f468a23d424e"
          "&credit=2"
          "&sender=SATJEW"
          "&message=$message"
          "&number=$mobno"
          "&templateid=1707174048352596410";

      commonUtils.log.i(smsApiUrl);

      try {
        // Send HTTP request
        var response = await http.get(Uri.parse(smsApiUrl));

        if (response.statusCode == 200) {
          commonUtils.log.i("SMS Sent Successfully!");
        } else {
          commonUtils.log.i("Failed to send SMS: ${response.body}");
        }
      } catch (e) {
        commonUtils.log.i("Error sending SMS: $e");
      }
    } else {
      commonUtils.log.i("Customer name not found in SharedPreferences!");
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String calTotAmt() {
    double TotAmt = double.parse(AmtPerMonth.toString()) *
        double.parse(NoOfInstall.toString());
    return TotAmt.toString();
  }

  Future<String> calDatMaturity() async {
    if (NoOfInstall == null ||
        commonUtils == null ||
        commonUtils.selectedDate == null) {
      return '';
    }

    int numOfInstallments = int.tryParse(NoOfInstall.toString()) ?? 0;
    commonUtils.log.i(numOfInstallments);

    DateTime maturityDate;

    if (numOfInstallments == 365) {
      maturityDate = commonUtils.selectedDate.add(Duration(days: 365));
    } else {
      maturityDate =
          commonUtils.selectedDate.add(Duration(days: 30 * numOfInstallments));
    }

    setState(() {
      EndDate = commonUtils.formatDate(maturityDate);
    });
    commonUtils.log.i("Maturity Date: ${EndDate.toString()}");
    return commonUtils.formatDate(maturityDate);
  }

  bool _termsAccepted = false;

  Future<void> GetCurrentDate() async {
    CurrentDate = commonUtils.formatDate(commonUtils.selectedDate) ?? 'N/A';
  }

  Future<void> _loadAccNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accNo = prefs.getString('accno');
    });
  }

  Future<void> _retrieveData() async {
    try {
      String? albumJson =
          SharedPreferencesHelper.getString('MdlNewScheme') ?? '';

      if (albumJson != null && albumJson.isNotEmpty) {
        // Fluttertoast.showToast(msg: "MdlNewScheme");
        commonUtils.log.i(albumJson);
        Map<String, dynamic> albumMap = jsonDecode(albumJson);
        setState(() {
          albumList = [albumMap];
        });

        if (albumList!.isNotEmpty) {
          schemeName = albumList![0]['schemeName'] ?? '';
          NoOfInstall = albumList![0]['noIns'] ?? '';
          AmtPerMonth = albumList![0]['schemeAmount'] ?? '';
          schemeType = albumList![0]['schemeType'] ?? '';
          commonUtils.log
              .i("$schemeName $NoOfInstall $AmtPerMonth $schemeType ");
        }
      } else {
        albumJson = SharedPreferencesHelper.getString('MdlMysavingsScheme');
        if (albumJson != null && albumJson.isNotEmpty) {
          Map<String, dynamic> albumMap = jsonDecode(albumJson);
          setState(() {
            albumList = [albumMap];
          });
          if (albumList!.isNotEmpty) {
            schemeName = albumList![0]['SCHNAME'] ?? '';
            NoOfInstall = albumList![0]['NOINS'] ?? '0';
            AmtPerMonth = albumList![0]['GROUPCODE'] ?? '0';
            schemeType = albumList![0]['SCHEMETYPE'] ?? '';
          }
        } else {
          commonUtils.log.e("I am in MdlSavingScheme");
        }
      }
    } catch (e) {
      commonUtils.log.e("Error: $e");
    }
  }

  Future<void> _initializeRazorKeyData() async {
    futureMdlCompanyData = _fetchCompanyData();

    futureMdlCompanyData.then((CompanyData) {
      if (CompanyData.isNotEmpty) {
        setState(() {
          Razor_key = CompanyData[0].razor_key ?? '';
        });
      }
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error fetching company data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "PAYMENT",
          style: Commontextsize.CommonLargeSize(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Column(
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 170,
                    width: 360,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/Card1.png',
                          )),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(username!,
                          style: GoogleFonts.raleway(
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  schemeType == 'WEIGHT'
                                      ? 'ENTER AMOUNT'
                                      : 'MONTHLY AMOUNT',
                                  style: GoogleFonts.lato(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  schemeType == 'WEIGHT'
                                      ? enteredAmount!
                                      : AmtPerMonth!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'TOTAL ${schemeType == 'WEIGHT' ? 'WEIGHT' : 'AMOUNT'}',
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  schemeType == 'WEIGHT'
                                      ? enterWeight!
                                      : calTotAmt(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SCHEME NAME',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Text(
                        schemeName!,
                        style: Commontextsize.CommonMediumSize(),
                      ),
                      Divider(),
                      SizedBox(height: 15),
                      Text(
                        'INSTALLMENT',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Text(
                        NoOfInstall!,
                        style: Commontextsize.CommonMediumSize(),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  'DATE-OF-JOINING',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  CurrentDate!,
                                  style: Commontextsize.CommonMediumSize(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 70),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  'DATE-OF-MATURITY',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  EndDate.toString(),
                                  style: Commontextsize.CommonMediumSize(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            CheckboxListTile(
              title: Text("I agree to the terms and conditions",
                  style: commonTextStyleMedium(color: AppColors.CommonColor)),
              value: _termsAccepted,
              onChanged: (bool? value) {
                setState(() {
                  _termsAccepted = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${schemeType == 'WEIGHT' ? enteredAmount! : AmtPerMonth!}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue.shade900,
                      )),
                  onPressed: () {
                    if (_termsAccepted) {
                      calDatMaturity().then((_) {
                        OnPayPressed();
                      });
                    } else {
                      commonUtils.showToast("Please Accept Terms & Condition",
                          backgroundColor: AppColors.CommonRed);
                    }
                  },
                  child: Text(
                    'PROCEED TO PAY',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
