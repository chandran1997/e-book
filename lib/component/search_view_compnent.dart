import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/component/view_all_book_component.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';

class SearchViewComponent extends StatefulWidget {
  static String tag = '/SearchViewComponent';
  final List<DashboardBookInfo>? mBookList;
  final bool? isNoSearchResultFound;

  SearchViewComponent({this.mBookList, this.isNoSearchResultFound});

  @override
  SearchViewComponentState createState() => SearchViewComponentState();
}

class SearchViewComponentState extends State<SearchViewComponent> {
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
      children: <Widget>[
        AnimationLimiter(
          child: ListView.separated(
              padding: EdgeInsets.all(0),
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey.withOpacity(0.3));
              },
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              itemCount: widget.mBookList!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                DashboardBookInfo mData = widget.mBookList![index];
                var categoryName;
                mData.categories.validate().forEach((element) {
                  categoryName = element.name;
                });
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: 900.milliseconds,
                  child: SelectedAnimationType(
                    scale: 5,
                    curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.decelerate : Curves.fastLinearToSlowEaseIn,
                    child: ViewAllBookComponent(bookData: mData, categoryName: categoryName).paddingOnly(left: 16, right: 16, top: 8, bottom: 8).onTap(() {
                      BookDescriptionScreen(widget.mBookList![index].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    }),
                  ),
                );
              }),
        ),
        Container(
          child: Container(
            height: 300,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(margin: EdgeInsets.all(spacing_standard_30), child: Image.asset("logo.png", width: 150)),
                      Text(
                        keyString(context, "lbl_no_book_found")!,
                        style: TextStyle(fontSize: 20, color: appStore.appTextPrimaryColor),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).visible(widget.isNoSearchResultFound!)
      ],
    );
  }
}
