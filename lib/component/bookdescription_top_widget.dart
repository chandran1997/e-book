import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/adapterView/DownloadFilesView.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'dart:math' as math;
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class BookDescriptionTopWidget extends StatefulWidget {
  static String tag = '/BookDescriptionTopWidget';
  DashboardBookInfo? mBookDetailsData;
  final Color? bgColor;
  double? scrollPosition;
  bool? mIsFreeBook = false;
  List<DownloadModel>? mDownloadPaidFileArray;
  String? mBookId;
  Function? onUpdate;
  Function? onAddToCartUpdate;
  Function? onUpdateBuyNow;

  BookDescriptionTopWidget(
      {this.mBookDetailsData, this.bgColor, this.scrollPosition, this.mIsFreeBook, this.mDownloadPaidFileArray, this.mBookId, this.onUpdate, this.onAddToCartUpdate, this.onUpdateBuyNow});

  @override
  BookDescriptionTopWidgetState createState() => BookDescriptionTopWidgetState();
}

class BookDescriptionTopWidgetState extends State<BookDescriptionTopWidget> {
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

  void getPaidFileList(context) {
    if (widget.mDownloadPaidFileArray!.length > 0) {
      _settingModalBottomSheet(context, widget.mDownloadPaidFileArray!);
    } else {
      widget.onUpdate!.call();
    }
  }

  void _settingModalBottomSheet(context, List<DownloadModel> viewFiles, {isSampleFile = false}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          primary: false,
          child: Container(
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), backgroundColor: appStore.editTextBackColor!),
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: spacing_standard_new,
                      ),
                      padding: EdgeInsets.only(right: spacing_standard),
                      child: Text(
                        keyString(context, "lbl_all_files")!,
                        style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.close, color: appStore.iconColor, size: 30),
                      onTap: () => {Navigator.of(context).pop()},
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: spacing_standard_new),
                  height: 2,
                  color: lightGrayColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DownloadFilesView(
                        widget.mBookId!,
                        viewFiles[index],
                        widget.mBookDetailsData!.images![0].src.validate(),
                        widget.mBookDetailsData!.name.validate(),
                        isSampleFile: isSampleFile,
                      );
                    },
                    itemCount: viewFiles.length,
                    shrinkWrap: true,
                  ),
                ).visible(viewFiles.isNotEmpty),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.mBookDetailsData!.name!.isNotEmpty
        ? LayoutBuilder(
            builder: (context, c) {
              final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
              final deltaExtent = settings!.maxExtent - settings.minExtent;
              final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
              final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
              const fadeEnd = 1.0;
              final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Opacity(
                    opacity: 1 - opacity,
                    child: Text(widget.mBookDetailsData!.name.validate(), style: boldTextStyle()),
                  ).center(),
                  Opacity(
                    opacity: opacity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                            backgroundColor: widget.bgColor ?? Colors.grey,
                          ),
                          height: 70,
                          width: 140,
                        ),
                        Container(
                          height: dashboard_book_height,
                          width: dashboard_book_width,
                          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(
                              child: bookLoaderWidget,
                            ),
                            width: 100,
                            height: dashboard_book_height,
                            imageUrl: widget.mBookDetailsData!.images![0].src.validate(),
                            fit: BoxFit.fill,
                          ),
                          margin: EdgeInsets.only(bottom: 16),
                        ),
                      ],
                    ).center().visible(widget.mBookDetailsData!.images![0].src!.isNotEmpty),
                  ),
                  Transform.translate(
                    offset: widget.scrollPosition! <= 230 ? Offset(0, 24) : Offset(0, context.height() * 0.050),
                    child: (widget.mBookDetailsData!.isPurchased! || widget.mIsFreeBook!)
                        ? AppButton(
                            color: PRIMARY_COLOR,
                            shapeBorder: RoundedRectangleBorder(borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                            width: (widget.scrollPosition! >= 230) ? context.width() : context.width() / 1.5,
                            child: Text(
                              keyString(context, "lbl_view_files")!,
                              style: primaryTextStyle(color: white),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              getPaidFileList(context);
                            },
                          )
                        : Container(
                            width: (widget.scrollPosition! >= 230) ? context.width() : context.width() / 1.3,
                            decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    myCartList.any((e) => e.proId.toString() == widget.mBookId) ? keyString(context, 'lbl_go_to_cart')! : keyString(context, 'lbl_add_to_cart')!,
                                    style: primaryTextStyle(color: white),
                                    textAlign: TextAlign.center,
                                  ),
                                ).onTap(() {
                                  widget.onAddToCartUpdate!.call();
                                }).expand(),
                                Container(
                                  height: 28,
                                  child: VerticalDivider(color: Colors.white, thickness: 1.5),
                                ),
                                Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    keyString(context, 'lbl_buy_now')!,
                                    style: primaryTextStyle(color: white),
                                  ),
                                ).onTap(() {
                                  widget.onUpdateBuyNow!.call();
                                }).expand(),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          )
        : Container();
  }
}
