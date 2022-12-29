import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'book_item_rounded_component.dart';
import 'category_book_view_all_component.dart';

class CategoryBookComponent extends StatefulWidget {
  static String tag = '/CategoryBookComponent';

  final Category? categoryBookData;

  CategoryBookComponent({this.categoryBookData});

  @override
  CategoryBookComponentState createState() => CategoryBookComponentState();
}

class CategoryBookComponentState extends State<CategoryBookComponent> {
  Category? categoryBookData;

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CategoryBookViewAllComponent(categoryBookData: widget.categoryBookData!).paddingOnly(top: 32, bottom: 16),
        Container(
          height: mobile_BookViewHeight,
          child: AnimationLimiter(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16),
              itemBuilder: (context, i) {
                Color bgColor = bookBackgroundColor[i % bookBackgroundColor.length];
                return AnimationConfiguration.staggeredList(
                  position: i,
                  duration: 600.milliseconds,
                  child: SelectedAnimationType(
                    duration: Duration(milliseconds: 700),
                    scale: 2.0,
                    curves: Curves.easeIn,
                    child: GestureDetector(
                      child: Container(color: appStore.scaffoldBackground, width: bookWidth, margin: EdgeInsets.only(right: 16), child: BookItemRoundedWidget(bookData: widget.categoryBookData!.product![i], bgColor: bgColor)),
                      onTap: () {
                        BookDescriptionScreen(widget.categoryBookData!.product![i].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                    ),
                  ),
                );
              },
              itemCount: widget.categoryBookData!.product!.length,
              shrinkWrap: true,
            ),
          ),
        )
      ],
    );
  }
}
