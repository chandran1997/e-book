import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_localizations.dart';

class AuthorDetailsHeaderComponent extends StatefulWidget {
  static String tag = '/AuthorDetailsComponent';
  final AuthorListResponse? authorDetails;
  final String? url;
  final String? fullName;

  AuthorDetailsHeaderComponent({this.authorDetails, this.url, this.fullName});

  @override
  AuthorDetailsHeaderComponentState createState() => AuthorDetailsHeaderComponentState();
}

class AuthorDetailsHeaderComponentState extends State<AuthorDetailsHeaderComponent> {
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
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            height: 80,
            width: 80,
            placeholder: (context, url) => Center(child: bookLoaderWidget),
            imageUrl: widget.url.validate(),
            fit: BoxFit.fill,
          ).cornerRadiusWithClipRRect(40),
          8.height,
          Text(
            widget.fullName.validate(),
            style: boldTextStyle(color: Colors.white, size: 22),
          ).visible(widget.fullName!.isNotEmpty),
          RatingBar.builder(
            allowHalfRating: true,
            ignoreGestures: true,
            initialRating: (widget.authorDetails!.rating!.rating.validate() == "")
                ? 00.00
                : double.parse(
                    widget.authorDetails!.rating!.rating.validate(),
                  ),
            minRating: 1,
            itemSize: 15.0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (double value) {},
          ).visible(widget.authorDetails!.rating!.rating.validate().isNotEmpty),
          16.height,
          RichTextWidget(list: [
            TextSpan(
              text: keyString(context, 'lbl_store_name')! + ': ',
              style: boldTextStyle(color: Colors.white),
            ),
            TextSpan(
              text: widget.authorDetails!.storeName.validate(),
              style: primaryTextStyle(color: Colors.white),
            ),
          ]).visible(widget.authorDetails!.storeName!.isNotEmpty),
          8.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/shop_icon.png', height: 22, width: 22, fit: BoxFit.fill, color: Colors.white),
              8.width,
              Text(
                widget.authorDetails!.shopUrl.validate(),
                style: secondaryTextStyle(color: Colors.white),
              ).onTap(() async {
                await launchUrl(Uri.parse(widget.authorDetails!.shopUrl.validate()), mode: LaunchMode.externalApplication);
              }).expand(),
            ],
          ).visible(widget.authorDetails!.shopUrl!.isNotEmpty)
        ],
      ),
    );
  }
}
