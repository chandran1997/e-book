import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/transaction_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NoInternetConnection.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String tag = '/TransactionHistoryScreen';

  @override
  TransactionHistoryScreenState createState() => TransactionHistoryScreenState();
}

class TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<BookPurchaseResponse> mOrderList = [];
  var mBookList = <LineItems>[];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getTransactionList();
  }

  Future getTransactionList() async {
    appStore.setLoading(true);

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getPurchasedRestApi().then((res) async {
          Iterable order = res;
          mOrderList = order.map((model) => BookPurchaseResponse.fromJson(model)).toList();
          appStore.setLoading(false);
        }).catchError((onError) {
          appStore.setLoading(false);
          log(onError.toString());
          if (appStore.isTokenExpired) {
            getTransactionList();
          } else {
            ErrorViewScreen(message: onError.toString()).launch(context);
          }
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, 'lbl_transaction_history')),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            ListView.builder(
                itemCount: mOrderList.length,
                padding: EdgeInsets.all(16),
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  BookPurchaseResponse mData = mOrderList[index];
                  return TransactionComponent(transactionListData: mData).paddingBottom(16);
                }).visible(!appStore.isLoading && mOrderList.isNotEmpty),
            noDataFound(title: keyString(context, 'lbl_no_transaction_data_found')!).center().visible(!appStore.isLoading && mOrderList.isEmpty),
            appLoaderWidget.center().visible(appStore.isLoading),
          ],
        );
      }),
    );
  }
}
