import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/OfflineBookList.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class FreeBookItemComponent extends StatefulWidget {
  static String tag = '/FreeBookItemComponent';
  final OfflineBookList? bookDetail;
  final Color? bgColor;
  final Function? onRemoveBookUpdate;

  FreeBookItemComponent({this.bookDetail, this.bgColor, this.onRemoveBookUpdate});

  @override
  FreeBookItemComponentState createState() => FreeBookItemComponentState();
}

class FreeBookItemComponentState extends State<FreeBookItemComponent> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                backgroundColor: widget.bgColor!,
              ),
              height: 40,
              width: 80,
            ),
            Container(
              height: 80,
              width: 60,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: bookLoaderWidget,
                ),
                height: 80,
                width: 60,
                imageUrl: widget.bookDetail!.frontCover!.validate(),
                fit: BoxFit.fill,
              ),
              margin: EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.bookDetail!.bookName.validate()}', style: primaryTextStyle(), maxLines: 2),
            8.height,
            InkWell(
              child: Container(
                height: 35,
                width: 35,
                alignment: Alignment.center,
                decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.delete, color: Colors.red),
              ),
              onTap: () {
                widget.onRemoveBookUpdate!.call(widget.bookDetail);
              },
            ),
          ],
        ),
      ],
    ).paddingRight(16);
  }
}
