import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/adapterView/DownloadFilesViewOffline.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/free_book_item_component.dart';
import 'package:flutterapp/model/OfflineBookList.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class FreeBookListComponent extends StatefulWidget {
  static String tag = '/FreeBookListComponent';
  final List<OfflineBookList>? downloadedList;
  final Function? onRemoveBookUpdate;

  FreeBookListComponent({this.downloadedList, this.onRemoveBookUpdate});

  @override
  FreeBookListComponentState createState() => FreeBookListComponentState();
}

class FreeBookListComponentState extends State<FreeBookListComponent> {
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

  void _settingModalBottomSheet(context, OfflineBookList downloadData) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          primary: false,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: spacing_standard_new),
                      padding: EdgeInsets.only(right: spacing_standard),
                      child: Text(
                        keyString(context, 'lbl_all_files')!,
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
                Container(margin: EdgeInsets.only(top: spacing_standard_new), height: 2, color: lightGrayColor),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DownloadFilesViewOffline(
                        downloadData.bookId,
                        downloadData.offlineBook[index],
                        downloadData.frontCover,
                        downloadData.bookName,
                      );
                    },
                    itemCount: downloadData.offlineBook.length,
                    shrinkWrap: true,
                  ),
                ).visible(downloadData.offlineBook.isNotEmpty),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: (widget.downloadedList!.length < 1)
          ? freeBookNotAvailableWidget(context).paddingTop(context.height() * 0.2)
          : Column(
              children: [
                titleSilverAppBarWidget(context, title1: keyString(context, 'lbl_my'), title2: keyString(context, 'lbl_free_library'), isHome: false).paddingSymmetric(horizontal: 16),
                16.height,
                AnimationLimiter(
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                        OfflineBookList bookDetail = widget.downloadedList![index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: 600.milliseconds,
                          child: SelectedAnimationType(
                            duration: Duration(milliseconds: 700),
                            scale: 2.0,
                            curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.decelerate : Curves.fastLinearToSlowEaseIn,
                            child: FreeBookItemComponent(
                              bookDetail: bookDetail,
                              bgColor: bgColor,
                              onRemoveBookUpdate: (OfflineBookList bookDetail) {
                                widget.onRemoveBookUpdate!.call(bookDetail);
                                setState(() {});
                              },
                            ).paddingOnly(top: 16, bottom: 16, left: 16).onTap(() {
                              _settingModalBottomSheet(context, bookDetail);
                            }),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey.withOpacity(0.3), height: 0);
                      },
                      itemCount: widget.downloadedList!.length),
                )
              ],
            ),
    );
  }
}
