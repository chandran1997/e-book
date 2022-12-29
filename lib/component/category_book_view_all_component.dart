import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CategoryBookViewAllComponent extends StatefulWidget {
  static String tag = '/CategoryBookViewAllComponent';

  final Category? categoryBookData;

  CategoryBookViewAllComponent({this.categoryBookData});

  @override
  CategoryBookViewAllComponentState createState() => CategoryBookViewAllComponentState();
}

class CategoryBookViewAllComponentState extends State<CategoryBookViewAllComponent> {
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
      children: <Widget>[
        Html(
          data: widget.categoryBookData!.name,
          style: {
            "body": Style(
              fontSize: FontSize(20),
              fontWeight: FontWeight.bold,
              color: appStore.appTextPrimaryColor,
              margin: Margins.zero,
              padding: EdgeInsets.zero,
            ),
          },
        ).expand(),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.chevron_right),
          iconSize: 30,
          onPressed: () {
            ViewAllBooksScreen(
              isCategoryBook: true,
              categoryId: widget.categoryBookData!.catID.toString(),
              categoryName: widget.categoryBookData!.name,
            ).launch(context);
          },
        )
      ],
    ).onTap(() {
      ViewAllBooksScreen(
        isCategoryBook: true,
        categoryId: widget.categoryBookData!.catID.toString(),
        categoryName: widget.categoryBookData!.name,
      ).launch(context);
    }).paddingOnly(left: 16, right: 8);
  }
}
