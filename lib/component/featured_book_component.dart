import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/component/book_item_rounded_component.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class FeaturedBookComponent extends StatefulWidget {
  static String tag = '/FeaturedBookComponent';

  final List<DashboardBookInfo>? mFeaturedBookModel;

  FeaturedBookComponent({this.mFeaturedBookModel});

  @override
  FeaturedBookComponentState createState() => FeaturedBookComponentState();
}

class FeaturedBookComponentState extends State<FeaturedBookComponent> {
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
    return Container(
      height: 220,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 16, top: 16),
          itemBuilder: (context, i) {
            DashboardBookInfo mData = widget.mFeaturedBookModel![i];
            Color bgColor = bookBackgroundColor[i % bookBackgroundColor.length];
            return AnimationConfiguration.staggeredList(
              position: i,
              duration: 600.milliseconds,
              child: SelectedAnimationType(
                duration: Duration(milliseconds: 700),
                scale: 2.0,
                curves: Curves.easeIn,
                child: GestureDetector(
                  child: Container(color: appStore.scaffoldBackground, width: bookWidth, margin: EdgeInsets.only(right: 16), child: BookItemRoundedWidget(bookData: mData, bgColor: bgColor)),
                  onTap: () {
                    BookDescriptionScreen(widget.mFeaturedBookModel![i].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
              ),
            );
          },
          itemCount: widget.mFeaturedBookModel!.length,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
