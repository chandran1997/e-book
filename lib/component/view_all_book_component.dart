import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ViewAllBookComponent extends StatefulWidget {
  static String tag = '/ViewAllBookComponent';
  final DashboardBookInfo? bookData;
  final String? categoryName;

  ViewAllBookComponent({this.bookData, this.categoryName});

  @override
  ViewAllBookComponentState createState() => ViewAllBookComponentState();
}

class ViewAllBookComponentState extends State<ViewAllBookComponent> {
  bool mIsFreeBook = false;
  bool mIsSalePrice = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getBookPrice();
  }

  Future<void> getBookPrice() async {
    if ((widget.bookData!.price.toString().isEmpty || widget.bookData!.price.toString() == "0") &&
            (widget.bookData!.salePrice.toString().isEmpty || widget.bookData!.salePrice.toString() == "0") &&
            widget.bookData!.regularPrice.toString().isEmpty ||
        widget.bookData!.regularPrice.toString() == "0") {
      // if((widget.bookData!.price == "" && widget.bookData!.price!="0") || (widget.bookData!.salePrice == "" && widget.bookData!.salePrice != "0") ||(widget.bookData!.regularPrice == "" && widget.bookData!.regularPrice != "0")){
      mIsFreeBook = true;
    } else {
      mIsFreeBook = false;
    }
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
        ClipRRect(
          child: CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: Container(height: 100, width: 80, child: bookLoaderWidget),
            ),
            imageUrl: widget.bookData!.images![0].src!.validate(),
            fit: BoxFit.cover,
            height: 100,
            width: 80,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bookData!.name.validate(), style: boldTextStyle()),
            4.height,
            RatingBar.builder(
              initialRating: widget.bookData!.ratingCount!.toDouble(),
              allowHalfRating: true,
              ignoreGestures: true,
              minRating: 0,
              itemSize: 15.0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              unratedColor: Colors.grey,
              onRatingUpdate: (double value) {},
            ),
            8.height,
            Html(
              data: widget.categoryName,
              style: {
                "body": Style(fontSize: FontSize(12), color: appStore.appTextPrimaryColor, margin: Margins.zero, padding: EdgeInsets.zero),
              },
            ),
            Text(keyString(context, 'lbl_free')!, style: boldTextStyle(color: Colors.green)).visible(mIsFreeBook),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.bookData!.salePrice, style: boldTextStyle()).visible(widget.bookData!.salePrice.toString().isNotEmpty),
                16.width.visible(widget.bookData!.salePrice.toString().isNotEmpty),
                Row(
                  children: [
                    Text('${getStringAsync(CURRENCY_SYMBOL)}', style: boldTextStyle(color: PRIMARY_COLOR)).visible(widget.bookData!.regularPrice.toString().isNotEmpty),
                    Text(
                      '${widget.bookData!.regularPrice}',
                      style: boldTextStyle(
                          color: widget.bookData!.salePrice.toString().isNotEmpty ? Colors.grey : PRIMARY_COLOR,
                          decoration: widget.bookData!.salePrice.toString().isNotEmpty ? TextDecoration.lineThrough : TextDecoration.none),
                    ),
                  ],
                ).visible(widget.bookData!.regularPrice.toString().isNotEmpty)
              ],
            ).visible(widget.bookData!.regularPrice.toString().isNotEmpty || widget.bookData!.salePrice.toString().isNotEmpty)
          ],
        ).expand()
      ],
    );
  }
}
