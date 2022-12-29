import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';

class FeaturedViewAllComponent extends StatefulWidget {
  static String tag = '/FeaturedViewAllComponent';
  final List<DashboardBookInfo>? mFeaturedBookModel;

  FeaturedViewAllComponent({this.mFeaturedBookModel});

  @override
  FeaturedViewAllComponentState createState() => FeaturedViewAllComponentState();
}

class FeaturedViewAllComponentState extends State<FeaturedViewAllComponent> {
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
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 40,
                child: Center(
                  child: Text(keyString(context, "featured_books")!, overflow: TextOverflow.ellipsis, maxLines: 2, style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor)),
                ),
              ),
              Container(
                height: 40,
                child: Icon(
                  Icons.chevron_right,
                  color: appStore.iconColor,
                  size: 30.0,
                  textDirection: appStore.isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          ViewAllBooksScreen(title: keyString(context, "featured_books"), futureBook: true).launch(context);
        }).visible(widget.mFeaturedBookModel!.isNotEmpty);
  }
}
