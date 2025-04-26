import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayService {
  late Razorpay _razorpay;
  final BuildContext _context;

  RazorPayService(this._context) {
    _razorpay = Razorpay();
    _initializeEventHandlers();
  }

  void _initializeEventHandlers() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(
        _context, "Payment Error", "${response.code} - ${response.message}");
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId}",
      timeInSecForIosWeb: 4,
    );
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet Selected: ${response.walletName}",
      timeInSecForIosWeb: 4,
    );
  }

  Future<void> initializePayment(
      {required String amount,
      required String contact,
      required String email}) async {
    var options = {
      'key': 'rzp_live_0r7MVwwq87Gd2a',
      'amount': (double.parse(amount) * 100).toInt().toString(),
      'name': '',
      'description': 'Gold Chits',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      showAlertDialog(_context, "Initialization Error", "Error: $e");
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [continueButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void dispose() {
    _razorpay.clear();
  }
}
