import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';

class NewBookListComponent extends StatefulWidget {
  static String tag = '/NewBookListComponent';

  final DashboardBookInfo? newBookData;
  final Color? borderColor;

  NewBookListComponent({this.newBookData, this.borderColor});

  @override
  NewBookListComponentState createState() => NewBookListComponentState();
}

class NewBookListComponentState extends State<NewBookListComponent> {
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
      height: mobile_BookViewHeight,
      width: 110,
      margin: EdgeInsets.only(right: 16),
      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius), backgroundColor: appStore.scaffoldBackground!),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: dashboard_book_height,
                width: dashboard_book_width,
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: appStore.scaffoldBackground!,
                  border: Border.all(color: widget.borderColor ?? Colors.grey, width: 2),
                ),
                margin: EdgeInsets.only(left: 14, bottom: 8, top: 4),
              ),
              Positioned(
                right: 8,
                left: 8,
                top: 10,
                bottom: 4,
                child: Container(
                  height: dashboard_book_height,
                  width: dashboard_book_width,
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(8), backgroundColor: appStore.scaffoldBackground!, border: Border.all(color: widget.borderColor ?? Colors.grey, width: 2)),
                ),
              ),
              Positioned(
                top: 16,
                bottom: 0,
                child: Container(
                  height: dashboard_book_height,
                  width: dashboard_book_width,
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(child: bookLoaderWidget),
                    height: dashboard_book_height,
                    width: dashboard_book_width,
                    imageUrl: widget.newBookData!.images![0].src.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          8.height,
          Text(
            widget.newBookData!.name.validate().toString(),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            textAlign: TextAlign.start,
            style: primaryTextStyle(color: appStore.textSecondaryColor, size: 14),
          ),
        ],
      ),
    );
  }
}
