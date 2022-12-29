import 'package:flutter/material.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';

class YouLikeViewAllComponent extends StatefulWidget {
  static String tag = '/YouMayLikeComponent';

  @override
  YouLikeViewAllComponentState createState() => YouLikeViewAllComponentState();
}

class YouLikeViewAllComponentState extends State<YouLikeViewAllComponent> {
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
            top: spacing_standard_new,
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
                    keyString(context, "books_for_you")!,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewAllBooksScreen(
                title: keyString(context, "books_for_you"),
                suggestionBook: true,
              ),
            ),
          );
        });
  }
}
