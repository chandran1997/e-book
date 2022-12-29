import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/model/CategoryModel.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AllSubCategoryComponent extends StatefulWidget {
  static String tag = '/AllSubCategoryComponent';
  final List<CategoryModel>? mCategoryModel;

  AllSubCategoryComponent({this.mCategoryModel});

  @override
  AllSubCategoryComponentState createState() => AllSubCategoryComponentState();
}

class AllSubCategoryComponentState extends State<AllSubCategoryComponent> {
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
    return HorizontalList(
      itemCount: widget.mCategoryModel!.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(left: 16),
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8)),
          padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Html(
            data: widget.mCategoryModel![index].name!,
            shrinkWrap: true,
            style: {
              "body": Style(
                fontSize: FontSize(fontSizeMedium),
                color: appStore.isDarkModeOn ? PRIMARY_COLOR : textPrimaryColorGlobal,
              ),
            },
          ),
        ).onTap(() {
          ViewAllBooksScreen(isCategoryBook: true, categoryId: widget.mCategoryModel![index].id.toString(), categoryName: widget.mCategoryModel![index].name!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
        }).paddingOnly(top: 8, bottom: 8);
      },
    );
  }
}
