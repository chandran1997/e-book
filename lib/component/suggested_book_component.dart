import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'book_item_rounded_component.dart';

class SuggestedBookComponent extends StatefulWidget {
  static String tag = '/SuggestedBookComponent';
  final List<DashboardBookInfo>? mSuggestedBooksModel;

  SuggestedBookComponent({this.mSuggestedBooksModel});

  @override
  SuggestedBookComponentState createState() => SuggestedBookComponentState();
}

class SuggestedBookComponentState extends State<SuggestedBookComponent> {
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
            DashboardBookInfo mData = widget.mSuggestedBooksModel![i];
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
                    BookDescriptionScreen(widget.mSuggestedBooksModel![i].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ),
              ),
            );
          },
          itemCount: widget.mSuggestedBooksModel!.length,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
