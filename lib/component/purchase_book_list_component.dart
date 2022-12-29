import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/component/purchase_book_item_component.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/screens/book_description_screen.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class PurchaseBookListComponent extends StatefulWidget {
  static String tag = '/PurchaseBookListComponent';
  final List<LineItems>? mBookList;

  PurchaseBookListComponent({this.mBookList});

  @override
  PurchaseBookListComponentState createState() => PurchaseBookListComponentState();
}

class PurchaseBookListComponentState extends State<PurchaseBookListComponent> {
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
    return Stack(
      children: [
        Container(
          width: context.width(),
          child: (widget.mBookList!.length < 1)
              ? bookNotAvailableWidget(context, title: keyString(context, "lbl_you_don_t_have_any_purchased_book")!, buttonTitle: keyString(context, 'lbl_purchased_now')).paddingTop(context.height() * 0.2).center()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleSilverAppBarWidget(context, title1: keyString(context, 'lbl_my'), title2: keyString(context, 'lbl_purchased_library'), isHome: false).paddingSymmetric(horizontal: 16),
                    16.height,
                    AnimationLimiter(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: 600.milliseconds,
                              child: SelectedAnimationType(
                                duration: Duration(milliseconds: 700),
                                scale: 2.0,
                                curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.decelerate : Curves.fastLinearToSlowEaseIn,
                                child: PurchaseBookItemComponent(bookData: widget.mBookList![index], bgColor: bgColor).paddingOnly(top: 16, bottom: 16, left: 16).onTap(() {
                                  BookDescriptionScreen(widget.mBookList![index].productId.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                }),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey.withOpacity(0.3),
                              height: 0,
                            );
                          },
                          itemCount: widget.mBookList!.length),
                    )
                  ],
                ),
        ),
      ],
    );
  }
}
