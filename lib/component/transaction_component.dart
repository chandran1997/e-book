import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionComponent extends StatefulWidget {
  static String tag = '/TransactionComponent';
  final BookPurchaseResponse? transactionListData;

  TransactionComponent({this.transactionListData});

  @override
  TransactionComponentState createState() => TransactionComponentState();
}

class TransactionComponentState extends State<TransactionComponent> {
  LineItems? lineItems;
  String dateFormate = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    widget.transactionListData!.lineItems!.forEach((element) {
      lineItems = element;
    });
    dateFormate = DateFormat("yMMMd").format(DateTime.parse(widget.transactionListData!.dateCreated!.date.toString()));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(borderRadius: radius(), color: appStore.appColorPrimaryLightColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/order_id_icon.png', height: 24, width: 24, fit: BoxFit.fill, color: appStore.iconSecondaryColor),
              4.width,
              Text(widget.transactionListData!.orderKey.validate().splitAfter('order_'), style: secondaryTextStyle()).expand(),
              Text(widget.transactionListData!.status.capitalizeFirstLetter(), style: boldTextStyle(color: getOrderStatusColor(widget.transactionListData!.status.validate()))),
            ],
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                height: 100,
                width: 80,
                placeholder: (context, url) => Center(
                  child: bookLoaderWidget,
                ),
                imageUrl: lineItems!.productImages!.isNotEmpty ? lineItems!.productImages![0].src.validate() : '',
                fit: BoxFit.cover,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${lineItems!.name.validate()}', style: boldTextStyle(), maxLines: 2),
                  4.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/transaction_history.png', height: 24, width: 24, fit: BoxFit.fill, color: appStore.iconSecondaryColor),
                      4.width,
                      Text(widget.transactionListData!.transactionId.splitAfter('ch_').validate(value: "N/A"), style: secondaryTextStyle()),
                    ],
                  ),
                  4.height,
                  Text(dateFormate.validate(), style: secondaryTextStyle()),
                  8.height,
                  priceWidget(price: lineItems!.total.validate(), currency: getStringAsync(CURRENCY_SYMBOL)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
