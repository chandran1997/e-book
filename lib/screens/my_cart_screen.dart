import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/PaymentSheetComponent.dart';
import 'package:flutterapp/component/cart_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/LineItemModel.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/WebViewScreen.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NoInternetConnection.dart';
import 'book_description_screen.dart';
import 'sign_in_screen.dart';

class MyCartScreen extends StatefulWidget {
  final bool? isDescription;

  MyCartScreen({this.isDescription = false});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  bool mWebViewPayment = false;
  List<String>? priceList = [];
  List<LineItemsRequest> lineItems = [];
  String bookId = "";
  var total;

//  late NavigationController controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getCartItem();
  }

  Future<void> getCartItem() async {
    appStore.setLoading(true);

    await getCartBook().then((value) {
      Iterable mCart = value;
      myCartList.clear();
      myCartList.addAll(mCart.map((model) => MyCartResponse.fromJson(model)).toList());
      myCartList.forEach((element) {
        total = total.toString().toDouble().validate() + element.price.toString().toDouble();
        setState(() {});
      });
      appStore.setLoading(false);
    }).catchError((onError) {
      appStore.setLoading(false);
    });
  }

  Future webViewPayment(BuildContext context) async {
    placeOrder(context);
  }

  ///WebView API
  Future placeOrder(BuildContext context) async {
    myCartList.forEach((element) {
      var lineItem = LineItemsRequest();
      lineItem.product_id = element.proId;
      lineItem.quantity = element.quantity;
      lineItems.add(lineItem);

      setState(() {});
    });

    var request = {
      'currency': getStringAsync(CURRENCY_NAME),
      'customer_id': appStore.userId,
      'payment_method': "",
      'set_paid': false,
      'status': "pending",
      'transaction_id': "",
      'line_items': lineItems,
    };

    log(request);
    setState(() {
      mWebViewPayment = true;
    });
    await isNetworkAvailable().then(
      (bool) async {
        if (bool) {
          await bookOrderRestApi(request).then((response) {
            if (!mounted) return;
            processPaymentApi(response['id'], context);
          }).catchError((error) {
            appStore.setLoading(false);
            toast(error.toString());
          });
        } else {
          NoInternetConnection().launch(context);
        }
      },
    );
  }

  processPaymentApi(var mOrderId, BuildContext context) async {
    var request = {"order_id": mOrderId};
    checkoutURLRestApi(request).then((res) async {
      if (!mounted) return;
      setState(() {
        mWebViewPayment = false;
      });
      Map? results = await WebViewScreen(res['checkout_url'], "Payment", orderId: mOrderId.toString()).launch(context);
      if (results != null && results.containsKey('orderCompleted')) {
        setState(() {
          mWebViewPayment = true;
        });
        myCartList.forEach((element) {
          bookId = element.proId.toString();
        });
        appStore.removeCartCount(bookId);
        clearCart().then((response) {
          myCartList.clear();
          LiveStream().emit(REFRESH_LIST);
          mWebViewPayment = false;
        }).catchError((error) {
          mWebViewPayment = false;
          toast(error.toString());
        });
      } else {
        deleteOrder(mOrderId).then((value) => {log(value)}).catchError((error) {
          log(error);
        });
      }
    }).catchError((error) {
      log(error);
    });
  }

  ///delete order api call
  Future deleteOrder(orderId) async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    await isNetworkAvailable().then(
      (bool) async {
        if (bool) {
          await deleteOrderRestApi(orderId).then((res) async {}).catchError((onError) {
            ErrorViewScreen(
              message: onError.toString(),
            ).launch(context);
          });
        } else {
          NoInternetConnection().launch(context);
        }
      },
    );
  }

  Future<void> pay(BuildContext context) async {
    if (getStringAsync(PAYMENT_METHOD) != "native") {
      webViewPayment(context);
    } else {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext _context) {
          return PaymentSheetComponent(
            total.toString(),
            context,
            myCartList: myCartList,
            onCall: () {
              setState(() {
                getCartItem();
                finish(context);
              });
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    if (widget.isDescription!) {
      appStore.isDarkModeOn ? setStatusBarColor(appStore.isLoading ? appStore.scaffoldBackground! : appStore.scaffoldBackground!) : setStatusBarColor(appStore.isLoading ? appStore.scaffoldBackground! : Colors.grey.shade300);
    } else {
      setStatusBarColor(appStore.scaffoldBackground!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.scaffoldBackground!);
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: appStore.appBarColor,
        elevation: 0,
        title: Row(
          children: [
            Text(keyString(context, 'lbl_my_cart')!, style: boldTextStyle(size: 20)),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: myCartList.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                MyCartResponse cartData = myCartList[index];
                Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                return CartComponent(
                  bgColor: bgColor,
                  cartData: cartData,
                  onUpdate: () {
                    myCartList.removeAt(index);
                    total = 0;
                    getCartItem();
                    setState(() {});
                  },
                ).paddingBottom(16).onTap(() {
                  BookDescriptionScreen(myCartList[index].proId.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                });
              }).visible(!appStore.isLoading && myCartList.isNotEmpty),
          Observer(builder: (context) {
            return noDataFound(title: keyString(context, 'lbl_empty_cart')!).center().visible(!appStore.isLoading && myCartList.isEmpty);
          }),
          Observer(builder: (context) {
            return appLoaderWidget.center().visible(appStore.isLoading);
          }),
          CircularProgressIndicator().center().visible(mWebViewPayment),
        ],
      ),
      bottomNavigationBar: Container(
        height: 140,
        color: appStore.editTextBackColor,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(keyString(context, 'lbl_total')!, style: primaryTextStyle()).expand(),
                priceWidget(currency: getStringAsync(CURRENCY_SYMBOL), price: total.toString(), size: 22),
              ],
            ),
            16.height,
            AppButton(
              width: context.width(),
              onTap: () {
                showConfirmDialog(
                  context,
                  keyString(context, 'lbl_are_you_sure_want_to_checkout')!,
                  negativeText: keyString(context, 'lbl_no')!,
                  positiveText: keyString(context, 'lbl_yes')!,
                ).then((value) async {
                  if (value ?? false) {
                    await pay(context);
                    setState(() {});
                  }
                }).catchError((e) {
                  toast(e.toString());
                });
              },
              height: 40,
              text: keyString(context, 'lbl_check_out')!,
              textStyle: boldTextStyle(color: white),
              color: PRIMARY_COLOR,
            )
          ],
        ),
      ).visible(!appStore.isLoading && myCartList.isNotEmpty),
    );
  }
}
