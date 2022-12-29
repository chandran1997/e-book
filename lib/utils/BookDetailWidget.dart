import 'package:flutter/material.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'flutterwave/view/flutterwave_style.dart';

// FlutterWave Payment
final style = FlutterwaveStyle(
    appBarText: "My Standard Blue",
    buttonColor: Color(0xffd0ebff),
    appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
    buttonTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    appBarColor: Color(0xffd0ebff),
    dialogCancelTextStyle: TextStyle(
      color: Colors.redAccent,
      fontSize: 18,
    ),
    dialogContinueTextStyle: TextStyle(
      color: Colors.blue,
      fontSize: 18,
    ));

// RazorPayment
void openCheckout(Razorpay _razorPay, String mTotalAmount) async {
  var mAmount = double.parse(mTotalAmount) * 100.00;
  var options = {
    'key': RAZOR_KEY,
    'amount': mAmount,
    'name': RAZOR_PAY_NAME,
    'theme.color': RAZOR_PAY_COLOR,
    'description': RAZOR_PAY_DESCRIPTION,
    'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
    'external': {
      'wallets': ['paytm']
    }
  };

  try {
    _razorPay.open(options);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> showLoading(BuildContext context, String message) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
          width: double.infinity,
          height: 50,
          child: Text(message),
        ),
      );
    },
  );
}
