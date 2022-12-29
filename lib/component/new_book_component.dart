import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import 'new_book_list_component.dart';

class NewBookComponent extends StatefulWidget {
  static String tag = '/NewBookComponent';

  final List<DashboardBookInfo>? mNewestBookModel;

  NewBookComponent({this.mNewestBookModel});

  @override
  NewBookComponentState createState() => NewBookComponentState();
}

class NewBookComponentState extends State<NewBookComponent> {
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
      padding: EdgeInsets.only(left: 16, top: 16),
      spacing: 0,
      runSpacing: 0,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        Color borderColor = bookBackgroundColor[index % bookBackgroundColor.length];
        return new GestureDetector(
          child: NewBookListComponent(newBookData: widget.mNewestBookModel![index], borderColor: borderColor),
          onTap: () {
            BookDescriptionScreen(widget.mNewestBookModel![index].id.toString(), bgColor: borderColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
          },
        );
      },
      itemCount: widget.mNewestBookModel!.length,
    );
  }
}
