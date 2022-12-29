import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';

class NewBookAllComponent extends StatefulWidget {
  static String tag = '/NewBookAllComponent';

  final List<DashboardBookInfo>? mNewestBookModel;

  NewBookAllComponent({this.mNewestBookModel});

  @override
  NewBookAllComponentState createState() => NewBookAllComponentState();
}

class NewBookAllComponentState extends State<NewBookAllComponent> {
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
        padding: EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: Text(
                  keyString(context, "header_newest_book_title")!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: boldTextStyle(color: appStore.appTextPrimaryColor, size: 20),
                ),
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
        ViewAllBooksScreen(title: keyString(context, "newest_books"), newestBook: true).launch(context);
      },
    ).visible(widget.mNewestBookModel!.isNotEmpty);
  }
}
