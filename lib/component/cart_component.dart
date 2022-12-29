import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CartComponent extends StatefulWidget {
  static String tag = '/CartComponent';
  final MyCartResponse? cartData;
  final Function? onUpdate;
  final Color? bgColor;

  CartComponent({this.cartData, this.onUpdate, this.bgColor});

  @override
  CartComponentState createState() => CartComponentState();
}

class CartComponentState extends State<CartComponent> {
  // bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    ///
  }

  ///remove cart
  Future<void> removeFromCart(String? proId) async {
    appStore.setLoading(true);

    var request = {'pro_id': proId};

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        appStore.removeCartCount(proId!);
        await deletefromCart(request).then((res) async {
          widget.onUpdate!.call();
          appStore.setLoading(false);
        }).catchError((onError) {
          appStore.setLoading(false);
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                backgroundColor: widget.bgColor ?? Colors.grey,
              ),
              height: 60,
              width: 100,
            ),
            Container(
              height: 100,
              width: 80,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: bookLoaderWidget,
                ),
                height: 100,
                width: 80,
                imageUrl: widget.cartData!.thumbnail.validate(),
                fit: BoxFit.fill,
              ),
              margin: EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            2.height,
            Text(widget.cartData!.name.validate(), textAlign: TextAlign.start, style: boldTextStyle(size: 18)),
            4.height,
            Text(
              widget.cartData!.stockStatus.validate(),
              textAlign: TextAlign.start,
              style: primaryTextStyle(color: Colors.green),
            ),
            4.height,
            priceWidget(currency: getStringAsync(CURRENCY_SYMBOL), price: widget.cartData!.price.toDouble().toString())
          ],
        ).expand(),
        Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: radius(8),
                ),
                child: Icon(Icons.delete, color: Colors.red))
            .onTap(() {
          showConfirmDialog(
            context,
            keyString(context, 'lbl_are_you_sure_want_to_delete')!,
            negativeText: keyString(context, 'lbl_no')!,
            positiveText: keyString(context, 'lbl_yes')!,
          ).then((value) {
            if (value ?? false) {
              removeFromCart(widget.cartData!.proId.toString());
              setState(() {});
            }
          }).catchError((e) {
            toast(e.toString());
          });
        })
      ],
    );
  }
}
