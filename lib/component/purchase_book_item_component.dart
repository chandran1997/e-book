import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class PurchaseBookItemComponent extends StatefulWidget {
  static String tag = '/PurchaseBookItemComponent';
  final LineItems? bookData;
  final Color? bgColor;

  PurchaseBookItemComponent({this.bookData, this.bgColor});

  @override
  PurchaseBookItemComponentState createState() => PurchaseBookItemComponentState();
}

class PurchaseBookItemComponentState extends State<PurchaseBookItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
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
                backgroundColor: widget.bgColor!,
              ),
              height: 40,
              width: 80,
            ),
            Container(
              height: 80,
              width: 60,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: bookLoaderWidget,
                ),
                height: 80,
                width: 60,
                imageUrl: widget.bookData!.productImages![0].src!,
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
            Text('${widget.bookData!.name.validate()}', style: primaryTextStyle(), maxLines: 2),
            4.height,
            priceWidget(currency: getStringAsync(CURRENCY_SYMBOL), price: widget.bookData!.total.validate()),
          ],
        ).expand(),
      ],
    ).paddingRight(16);
  }
}
