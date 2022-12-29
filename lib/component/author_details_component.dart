import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorDetailsComponent extends StatefulWidget {
  static String tag = '/AuthorDetailsComponent';
  final DashboardBookInfo? bookData;
  final Color? bgColor;

  AuthorDetailsComponent({this.bookData, this.bgColor});

  @override
  AuthorDetailsComponentState createState() => AuthorDetailsComponentState();
}

class AuthorDetailsComponentState extends State<AuthorDetailsComponent> {
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
              height: 60,
              width: 100,
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
                width: 100,
                height: 100,
                imageUrl: widget.bookData!.images![0].src!.validate(),
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
            Text(widget.bookData!.name.validate(), style: boldTextStyle()),
            RatingBar.builder(
              initialRating: widget.bookData!.ratingCount!.toDouble(),
              allowHalfRating: true,
              ignoreGestures: true,
              minRating: 0,
              itemSize: 15.0,
              unratedColor: Colors.grey,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double value) {},
            ),
          ],
        ),
      ],
    ).paddingOnly(right: 16, top: 8, bottom: 8);
  }
}
