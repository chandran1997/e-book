import 'package:flutter/material.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';

// ignore: must_be_immutable
class BookDescriptionCategoryComponent extends StatefulWidget {
  DashboardBookInfo? bookDetailsData;

  BookDescriptionCategoryComponent(this.bookDetailsData);

  @override
  BookDescriptionCategoryComponentState createState() => BookDescriptionCategoryComponentState();
}

class BookDescriptionCategoryComponentState extends State<BookDescriptionCategoryComponent> {
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
          keyString(context, "lbl_categories")!,
          style: TextStyle(
            fontSize: 20,
            color: appStore.appTextPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ).visible(widget.bookDetailsData!.categories!.length > 0).paddingLeft(16),
        16.height,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.bookDetailsData!.categories!
                .map(
                  (item) => GestureDetector(
                    child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(left: 16),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(defaultRadius),
                          backgroundColor: appStore.isDarkModeOn ? appStore.appColorPrimaryLightColor! : Colors.white,
                        ),
                        child: Text(
                          '${HtmlUnescape().convert(item.name!)}',
                          style: boldTextStyle(size: 14),
                        )),
                    onTap: () {
                      ViewAllBooksScreen(
                        isCategoryBook: true,
                        categoryId: item.id.toString(),
                        categoryName: item.name,
                      ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    },
                  ),
                )
                .toList()
                .cast<Widget>(),
          ).paddingRight(16),
        ),
      ],
    );
  }
}
