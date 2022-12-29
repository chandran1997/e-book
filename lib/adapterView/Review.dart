import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class Review extends StatefulWidget {
  Reviews? reviews;

  Review(this.reviews);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(36),
          ),
          backgroundColor: appStore.isDarkModeOn ? appStore.appColorPrimaryLightColor! : Colors.white),
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.reviews!.commentAuthor!.toUpperCase(),
            textAlign: TextAlign.left,
            style: boldTextStyle(color: appStore.appTextPrimaryColor, size: 14),
          ),
          Text(
            widget.reviews!.commentContent!,
            textAlign: TextAlign.justify,
            maxLines: 5,
            style: secondaryTextStyle(
              color: appStore.textSecondaryColor,
            ),
          ),
          8.height,
          Container(
            width: 80,
            height: 13.31399917602539,
            child: RatingBar.builder(
              allowHalfRating: true,
              ignoreGestures: true,
              initialRating: (widget.reviews!.ratingNum == "") ? 00.00 : double.parse(widget.reviews!.ratingNum!),
              minRating: 1,
              itemSize: 15.0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double value) {},
            ),
          ),
          8.height,
          Text(
            reviewConvertDate(widget.reviews!.commentDate),
            textAlign: TextAlign.right,
            style: TextStyle(color: appStore.textSecondaryColor, fontSize: 14, fontWeight: FontWeight.normal, height: 1),
          ),
        ],
      ),
    );
  }
}
