import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/adapterView/DownloadFilesView.dart';
import 'package:flutterapp/component/book_description_category_component.dart';
import 'package:flutterapp/component/get_author_component.dart';
import 'package:flutterapp/model/AddtoBookmarkResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/screens/sign_in_screen.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';
import 'all_review_component.dart';
import 'more_book_from_author_component.dart';

// ignore: must_be_immutable
class BookDescriptionComponent extends StatefulWidget {
  static String tag = '/BookDescriptionComponent';
  DashboardBookInfo? mBookDetailsData;
  bool? mIsFreeBook;
  String? mBookId;
  var mSampleFile;
  List<DownloadModel>? mDownloadFileArray;

  List<MyCartResponse>? myCartList;

  BookDescriptionComponent({this.mBookDetailsData, this.mIsFreeBook, this.myCartList, this.mBookId, this.mSampleFile, this.mDownloadFileArray});

  @override
  BookDescriptionComponentState createState() => BookDescriptionComponentState();
}

class BookDescriptionComponentState extends State<BookDescriptionComponent> {
  bool checkVisible = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    widget.mBookDetailsData!.attributes!.forEach((element) {
      if (element.visible == "true") {
        checkVisible = true;
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  /// Remove Bookmark api call
  Future removeFromBookmark() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    setState(() {
      widget.mBookDetailsData!.isAddedWishlist = false;
    });
    var request = {'pro_id': widget.mBookId};
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getRemoveFromBookmarkRestApi(request).then((res) async {
          AddToBookmarkResponse response = AddToBookmarkResponse.fromJson(res);
          if (response.code == "success") {
            toast(response.message.toString());
            setState(() {
              widget.mBookDetailsData!.isAddedWishlist = false;
            });
          }
        }).catchError((onError) {
          setState(() {
            widget.mBookDetailsData!.isAddedWishlist = false;
          });
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          widget.mBookDetailsData!.isAddedWishlist = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  /// Add Bookmark api call
  Future addToBookmark() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    setState(() {
      widget.mBookDetailsData!.isAddedWishlist = true;
    });
    var request = {'pro_id': widget.mBookId};
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getAddToBookmarkRestApi(request).then((res) async {
          AddToBookmarkResponse response = AddToBookmarkResponse.fromJson(res);
          if (response.code == "success") {
            toast(response.message.toString());
            setState(() {
              widget.mBookDetailsData!.isAddedWishlist = true;
            });
          }
        }).catchError((onError) {
          setState(() {
            widget.mBookDetailsData!.isAddedWishlist = true;
          });
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          widget.mBookDetailsData!.isAddedWishlist = true;
        });
        NoInternetConnection().launch(context);
      }
    });
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
                      child: Icon(
                        Icons.close,
                        color: appStore.iconColor,
                        size: 30,
                      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.mBookDetailsData!.name.validate(),
              style: boldTextStyle(size: 22),
            ).expand(),
            Container(
              decoration: BoxDecoration(color: appStore.editTextBackColor, borderRadius: radius(12)),
              padding: EdgeInsets.all(8),
              child: (widget.mBookDetailsData != null)
                  ? widget.mBookDetailsData!.isAddedWishlist!
                      ? Icon(
                          Icons.bookmark,
                          color: PRIMARY_COLOR,
                          size: 24,
                        )
                      : Icon(
                          Icons.bookmark_border,
                          color: appStore.iconColor,
                          size: 24,
                        )
                  : SizedBox(),
            ).onTap(() {
              appStore.isLoggedIn
                  ? widget.mBookDetailsData!.isAddedWishlist!
                      ? removeFromBookmark()
                      : addToBookmark()
                  : SignInScreen(isBookDescription: true).launch(context);
            }),
          ],
        ).paddingSymmetric(horizontal: 16),
        priceWidget(currency: getStringAsync(CURRENCY_SYMBOL), price: widget.mBookDetailsData!.price!, size: 20).visible(!widget.mIsFreeBook!).paddingSymmetric(horizontal: 16),
        32.height,
        Text(
          keyString(context, 'lbl_what_is_about')!,
          style: boldTextStyle(color: appStore.appTextPrimaryColor, size: 20),
        ).paddingLeft(16),
        16.height,
        Divider(color: Colors.black.withOpacity(0.2)).paddingSymmetric(horizontal: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("sunglasses.png", width: 26, color: appStore.appTextPrimaryColor),
            8.width,
            Text(
              keyString(context, "lbl_free_trial")!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSizeMedium, color: appStore.appTextPrimaryColor),
            )
          ],
        ).visible(widget.mSampleFile.length > 0).onTap(() {
          _settingModalBottomSheet(context, widget.mDownloadFileArray!, isSampleFile: true);
        }).paddingSymmetric(horizontal: 16),
        Html(
          data: widget.mBookDetailsData!.description.validate(),
          style: {
            "body": Style(
              fontSize: FontSize(fontSizeMedium),
              color: appStore.textSecondaryColor,
              margin: Margins.zero,
              padding: EdgeInsets.zero,
            ),
          },
        ).paddingSymmetric(horizontal: 16),
        /*BookAttributeComponent(mBookDetailsData: widget.mBookDetailsData, checkVisible: checkVisible, mSampleFile: widget.mSampleFile).visible(
          isSingleSampleFile(widget.mBookDetailsData.attributes!.length, widget.mSampleFile),
        ),*/
        16.height,
        BookDescriptionCategoryComponent(widget.mBookDetailsData).visible(widget.mBookDetailsData!.categories!.length > 0),
        32.height,
        GetAuthorComponent(widget.mBookDetailsData),
        32.height,
        AllReviewComponent(
          widget.mBookDetailsData!,
          widget.mIsFreeBook,
          appStore.isLoggedIn,
          widget.mBookId!,
        ).visible(widget.mBookDetailsData!.reviewsAllowed!),
        16.height,
        MoreBookFromAuthorComponent(
          widget.mBookDetailsData,
        ).visible(widget.mBookDetailsData!.upsellId!.length > 0),
      ],
    );
  }
}
