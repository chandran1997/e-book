import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class BookItemRoundedWidget extends StatefulWidget {
  static String tag = '/BookItemRoundedWidget';
  final DashboardBookInfo? bookData;
  final Color? bgColor;

  BookItemRoundedWidget({this.bookData, this.bgColor});

  @override
  BookItemRoundedWidgetState createState() => BookItemRoundedWidgetState();
}

class BookItemRoundedWidgetState extends State<BookItemRoundedWidget> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                backgroundColor: widget.bgColor!,
              ),
              height: 70,
              width: 140,
            ),
            Container(
              height: dashboard_book_height,
              width: dashboard_book_width,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: bookLoaderWidget,
                ),
                width: 100,
                height: dashboard_book_height,
                imageUrl: widget.bookData!.images![0].src!,
                fit: BoxFit.fill,
              ),
              margin: EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
        8.height,
        Text(
          widget.bookData!.name.toString(),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          textAlign: TextAlign.start,
          style: primaryTextStyle(color: appStore.textSecondaryColor, size: 14),
        ),
      ],
    );
  }
}
