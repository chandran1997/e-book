import 'package:flutter/material.dart';
import 'package:flutterapp/adapterView/UpsellBookList.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class MoreBookFromAuthorComponent extends StatefulWidget {
  var bookDetailsData;

  MoreBookFromAuthorComponent(this.bookDetailsData);

  @override
  MoreBookFromAuthorComponentState createState() => MoreBookFromAuthorComponentState();
}

class MoreBookFromAuthorComponentState extends State<MoreBookFromAuthorComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          keyString(context, "lbl_more_books_from_author")!,
          style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
        ).paddingSymmetric(horizontal: 16),
        Container(
          height: 200,
          margin: EdgeInsets.only(bottom: 40),
          child: ListView.builder(
            padding: EdgeInsets.only(right: 25),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
              return UpsellBookList(widget.bookDetailsData.upsellId![index]).onTap(() {
                BookDescriptionScreen(widget.bookDetailsData.upsellId![index].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              });
            },
            itemCount: widget.bookDetailsData.upsellId!.length,
            shrinkWrap: true,
          ),
        )
      ],
    );
  }
}
