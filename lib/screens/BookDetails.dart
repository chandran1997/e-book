import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/adapterView/DownloadFilesView.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/PaymentSheetComponent.dart';
import 'package:flutterapp/component/all_review_component.dart';
import 'package:flutterapp/component/book_description_category_component.dart';
import 'package:flutterapp/component/more_book_from_author_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/AddtoBookmarkResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/model/PaidBookResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/author_wise_book_screen.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/admob_utils.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NoInternetConnection.dart';
import 'error_view_screeen.dart';
import 'my_cart_screen.dart';
import 'sign_in_screen.dart';

// ignore: must_be_immutable
class BookDetails extends StatefulWidget {
  var mBookId = "0";
  final Function? onUpdate;

  BookDetails(this.mBookId, {this.onUpdate});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  var mBookDetailsData;
  var mSampleFile = "";
  var mTotalAmount = "";

  List<DownloadModel> mDownloadFileArray = [];
  List<DownloadModel> mDownloadPaidFileArray = [];
  List<DashboardBookInfo> mBookDetailsList = [];

  var myCartList = <MyCartResponse>[];

  InterstitialAd? interstitialAd;

  bool mIsLoading = true;
  bool mReviewIsLoading = false;
  bool mFetchingFile = false;
  bool mIsFreeBook = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setState(() {
        mIsLoading = true;
      });
      init();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  init() async {
    mIsLoading = true;
    createInterstitialAd();
    setState(() {});
    getBookDetails();
    if (appStore.isLoggedIn) {
      getCartItem();
    }
  }

  adShow() async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    isAdsLoading ? interstitialAd!.show() : SizedBox();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getInterstitialAdUnitId()!,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            interstitialAd = null;
          },
        ));
  }

  // Book Detail API
  Future<void> getBookDetails({afterPayment = false}) async {
    if (afterPayment) {
      setState(() {
        mFetchingFile = true;
      });
    } else {
      setState(() {
        mIsLoading = true;
      });
    }
    await isNetworkAvailable().then((bool) async {
      setState(() {
        mIsLoading = true;
      });
      if (bool) {
        var request = {
          'product_id': widget.mBookId,
        };
        await getBookDetailsRestApi(request).then((res) async {
          log("book details$res");
          if (afterPayment) {
            mFetchingFile = false;
          } else {
            mIsLoading = false;
          }
          mBookDetailsList = res;
          mBookDetailsData = mBookDetailsList[0];

          if (mBookDetailsData.type == "variable" || mBookDetailsData.type == "grouped" || mBookDetailsData.type == "external") {
            toastLong("Book type not supported");
            Navigator.of(context).pop();
          }

          if (mBookDetailsData.price == "" && mBookDetailsData.salePrice == "" && mBookDetailsData.regularPrice == "") {
            mIsFreeBook = true;
          } else {
            mIsFreeBook = false;
          }

          getBookPrice();

          // Get sample files url
          mDownloadFileArray.clear();
          mSampleFile = "";
          for (var i = 0; i < mBookDetailsData.attributes!.length; i++) {
            if (mBookDetailsData.attributes![i].name == SAMPLE_FILE) {
              if (mBookDetailsData.attributes![i].options!.length > 0) {
                mSampleFile = "ContainsDownloadFiles";
                var dv = DownloadModel();
                dv.id = "1";
                dv.name = "Sample File";
                dv.file = mBookDetailsData.attributes![i].options![0].toString();
                mDownloadFileArray.add(dv);
              }
            }
          }
          setState(() {});
        }).catchError((onError) {
          setState(() {
            if (afterPayment) {
              mFetchingFile = false;
            } else {
              mIsLoading = false;
            }
          });
          if (appStore.isTokenExpired) {
            getBookDetails();
          } else {
            ErrorViewScreen(
              message: onError.toString(),
            ).launch(context);
          }
        });
      } else {
        setState(() {
          if (afterPayment) {
            mFetchingFile = false;
          } else {
            mIsLoading = false;
          }
        });

        NoInternetConnection().launch(context);
      }
    });
  }

  Future getPaidFileDetails() async {
    setState(() {
      mFetchingFile = true;
    });

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        String time = await getTime();
        var request = {'book_id': widget.mBookId, 'time': time, 'secret_salt': await getKey(time)};
        await getPaidBookFileListRestApi(request).then((res) async {
          setState(() {
            mFetchingFile = false;
          });
          PaidBookResponse paidBookDetails = PaidBookResponse.fromJson(res);

          mDownloadPaidFileArray.clear();
          for (var i = 0; i < paidBookDetails.data!.length; i++) {
            var dv = DownloadModel();
            dv.id = paidBookDetails.data![i].id;
            dv.name = paidBookDetails.data![i].name;
            dv.file = paidBookDetails.data![i].file;
            mDownloadPaidFileArray.add(dv);
          }
          _settingModalBottomSheet(context, mDownloadPaidFileArray);
        }).catchError((onError) {
          setState(() {
            mFetchingFile = false;
          });
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          mFetchingFile = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  // get Additional Information
  String getAllAttribute(Attributes attribute) {
    String attributes = "";
    for (var i = 0; i < attribute.options!.length; i++) {
      attributes = attributes + attribute.options![i];
      if (i < attribute.options!.length - 1) {
        attributes = attributes + ", ";
      }
    }
    return attributes;
  }

  bool isSingleSampleFile(int? count) {
    if (count == 0) {
      return false;
    } else if (count == 1 && mSampleFile.length > 0) {
      return false;
    }
    return true;
  }

  Future<void> getBookPrice() async {
    mTotalAmount = "";
    if (mBookDetailsData.onSale!) {
      mTotalAmount = mTotalAmount + mBookDetailsData.salePrice;
    } else {
      mTotalAmount = mTotalAmount + mBookDetailsData.regularPrice;
    }
  }

  void getPaidFileList(context) {
    if (mDownloadPaidFileArray.length > 0) {
      _settingModalBottomSheet(context, mDownloadPaidFileArray);
    } else {
      getPaidFileDetails();
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
                        style: boldTextStyle(
                          size: 20,
                          color: appStore.appTextPrimaryColor,
                        ),
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
                        widget.mBookId,
                        viewFiles[index],
                        mBookDetailsData.images![0].src,
                        mBookDetailsData.name,
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

  // Remove Bookmark
  Future removeFromBookmark() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    setState(() {
      mBookDetailsData.isAddedWishlist = false;
    });
    var request = {'pro_id': widget.mBookId};
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getRemoveFromBookmarkRestApi(request).then((res) async {
          AddToBookmarkResponse response = AddToBookmarkResponse.fromJson(res);
          if (response.code == "success") {
            setState(() {
              mBookDetailsData.isAddedWishlist = false;
            });
          }
        }).catchError((onError) {
          setState(() {
            mBookDetailsData.isAddedWishlist = false;
          });
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          mBookDetailsData.isAddedWishlist = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  // Add Bookmark
  Future addToBookmark() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    setState(() {
      mBookDetailsData.isAddedWishlist = true;
    });
    var request = {'pro_id': widget.mBookId};
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getAddToBookmarkRestApi(request).then((res) async {
          AddToBookmarkResponse response = AddToBookmarkResponse.fromJson(res);
          if (response.code == "success") {
            setState(() {
              mBookDetailsData.isAddedWishlist = true;
            });
          }
        }).catchError((onError) {
          setState(() {
            mBookDetailsData.isAddedWishlist = true;
          });
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          mBookDetailsData.isAddedWishlist = true;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  //cart
  Future<void> addToCard() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    setState(() {
      mReviewIsLoading = true;
    });
    var request = {'pro_id': widget.mBookId, "quantity": "1"};
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await addToCartBook(request).then((res) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(keyString(context, 'lbl_added_to_cart')!),
            ),
          );
          getCartItem();
          appStore.setAddToCart(true);
          setState(() {
            // isAddedToCart = true;
            mReviewIsLoading = false;
          });
        }).catchError((onError) {
          log(onError.toString());
          setState(() {
            mReviewIsLoading = false;
          });
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<void> getCartItem() async {
    await getCartBook().then((value) {
      Iterable mCart = value;
      myCartList.clear();
      myCartList = mCart.map((e) {
        return MyCartResponse.fromJson(e);
      }).toList();
      myCartList.forEach((element) {
        if (element.proId.validate() == widget.mBookId.toInt()) {
          /*setState(() {
            isAddedToCart = true;
          });*/
          appStore.setAddToCart(true);
        }
      });
      setState(() {
        mIsLoading = false;
      });
      log(myCartList);
      setState(() {});
    }).catchError((onError) {
      log(onError.toString());
      setState(() {
        mIsLoading = false;
      });
    });
  }

  Future<void> removeFromCart() async {
    setState(() {
      mIsLoading = true;
    });

    var request = {'pro_id': widget.mBookId};

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await deletefromCart(request).then((res) async {
          getCartItem();

          setState(() {});
        }).catchError((onError) {
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  //Buy
  Future<void> buyNow() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext _context) {
        return StatefulBuilder(builder: (BuildContext mContext, setState) {
          return PaymentSheetComponent(
            mTotalAmount.toString(),
            context,
            mIsDetail: true,
            myCartList: myCartList,
            mBookId: widget.mBookId,
          );
          //
        });
      },
    ).then((res) {
      if (res ?? true) {
        setState(() {
          mIsLoading = true;
          removeFromCart();
          getCartItem();
          getBookDetails(afterPayment: true);
        });
      }
    });
  }

  @override
  void dispose() async {
    if (interstitialAd != null) {
      if (mAdShowCount < 5) {
        mAdShowCount++;
      } else {
        mAdShowCount = 0;
        adShow();
      }
      interstitialAd?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set additional information
    Widget getAttribute() {
      var checkVisible = false;
      mBookDetailsData.attributes!.forEach((element) {
        if (element.visible == "true") {
          checkVisible = true;
        }
      });
      return Column(
        children: [
          Text(
            keyString(context, "lbl_additional_information")!,
            style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
          ).visible(isSingleSampleFile(mBookDetailsData.attributes!.length) && checkVisible == true).paddingOnly(left: 16, right: 16),
          ListView.builder(
            itemCount: mBookDetailsData.attributes!.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              return Container(
                child: (mBookDetailsData.attributes![i].name == SAMPLE_FILE && !mBookDetailsData.attributes![i].visible)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mBookDetailsData.attributes![i].name! + " : ",
                            style: TextStyle(fontSize: fontSizeMedium, color: textSecondaryColor, fontWeight: FontWeight.bold),
                          ),
                          4.width,
                          Expanded(
                            child: Text(
                              getAllAttribute(mBookDetailsData.attributes![i]),
                              style: TextStyle(fontSize: fontSizeMedium, color: textSecondaryColor),
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
              );
            },
          ),
        ],
      );
    }

    Widget getAuthor() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(mBookDetailsData.store.image),
                  ),
                ),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mBookDetailsData.store.name.toString().trim(),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeMedium,
                      color: appStore.appTextPrimaryColor,
                    ),
                  ),
                  Text(
                    keyString(context, "lbl_tap_to_see_author_details")!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      color: appStore.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: appStore.iconSecondaryColor,
            size: 32.0,
            textDirection: appStore.isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
        ],
      ).paddingOnly(left: 16, right: 16).onTap(() {
        /*AuthorDetailsCopy(
          mBookDetailsData.store.image,
          mBookDetailsData.store.name,
          authorDetails1: mBookDetailsData.store,
          isDetail: true,
        ).launch(context);*/
        AuthorWiseBookScreen(
          mBookDetailsData.store.image,
          mBookDetailsData.store.name,
          authorDetails1: mBookDetailsData.store,
          isDetail: true,
        ).launch(context);
      });
    }

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: Stack(
        alignment: Alignment.center,
        children: [
          mBookDetailsData != null && !mIsLoading
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.arrow_back, color: appStore.iconColor).onTap(() {
                            finish(context);
                          }),
                          Align(
                            alignment: appStore.isRTL ? Alignment.topLeft : Alignment.topRight,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.only(right: 8),
                                  onPressed: () async {
                                    if (appStore.isLoggedIn) {
                                      var res = await MyCartScreen().launch(context);
                                      log(res);
                                      if (res ?? true) {
                                        getBookDetails(afterPayment: true);
                                        getCartItem();
                                      }
                                    } else {
                                      SignInScreen().launch(context);
                                    }
                                  },
                                  icon: Icon(Icons.shopping_cart_outlined, color: appStore.iconColor, size: 26),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: redColor),
                                  child: Text(
                                    myCartList.length.toString(),
                                    style: primaryTextStyle(size: 12, color: white),
                                  ).paddingAll(4),
                                ).visible(myCartList.isNotEmpty)
                              ],
                            ),
                          ),
                        ],
                      ),
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          width: bookWidthDetails,
                          height: bookHeightDetails,
                          placeholder: (context, url) => Center(
                            child: bookLoaderWidget,
                          ),
                          imageUrl: mBookDetailsData.images![0].src!,
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 5,
                      ).center().visible(mBookDetailsData.images![0].src! != null),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mBookDetailsData.name!,
                                style: boldTextStyle(
                                  size: 18,
                                  color: appStore.appTextPrimaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                getStringAsync(CURRENCY_SYMBOL) + mBookDetailsData.price!,
                                style: boldTextStyle(
                                  size: 20,
                                  color: appStore.appTextPrimaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ).visible(!mIsFreeBook),
                            ],
                          ).expand(),
                          Container(
                            decoration: BoxDecoration(color: appStore.editTextBackColor, borderRadius: radius(12)),
                            padding: EdgeInsets.all(8),
                            child: (mBookDetailsData != null)
                                ? mBookDetailsData.isAddedWishlist!
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
                                ? mBookDetailsData.isAddedWishlist!
                                    ? removeFromBookmark()
                                    : addToBookmark()
                                : SignInScreen().launch(context);
                          }),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      8.height,
                      if (mBookDetailsData.isPurchased! || mIsFreeBook)
                        AppButton(
                          color: PRIMARY_COLOR,
                          width: context.width(),
                          onTap: () {
                            getPaidFileList(context);
                          },
                          text: keyString(context, "lbl_view_files")!.toUpperCase(),
                          textStyle: primaryTextStyle(color: white),
                        ).paddingSymmetric(horizontal: 16)
                      else
                        Container(
                          width: context.width(),
                          decoration: BoxDecoration(
                            color: PRIMARY_COLOR,
                            borderRadius: radius(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Observer(
                                builder: (_) => TextButton(
                                  onPressed: () {
                                    appStore.isLoggedIn
                                        ? !appStore.isAddToCart
                                            ? addToCard()
                                            : MyCartScreen().launch(context)
                                        : SignInScreen().launch(context);
                                  },
                                  child: Text(
                                    !appStore.isAddToCart ? keyString(context, 'lbl_add_to_cart')!.toUpperCase() : keyString(context, 'lbl_go_to_cart')!.toUpperCase(),
                                    style: primaryTextStyle(color: white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Container(
                                height: 28,
                                child: VerticalDivider(color: Colors.white, thickness: 1.5),
                              ),
                              TextButton(
                                onPressed: () {
                                  appStore.isLoggedIn ? buyNow() : SignInScreen().launch(context);
                                },
                                child: Text(
                                  keyString(context, 'lbl_buy_now')!.toUpperCase(),
                                  style: primaryTextStyle(color: white),
                                ),
                              ),
                            ],
                          ),
                        ).paddingSymmetric(horizontal: 16),
                      16.height,
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: appStore.editTextBackColor!,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32),
                            topLeft: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            24.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  keyString(context, "lbl_intro")!,
                                  style: boldTextStyle(
                                    size: 20,
                                    color: appStore.appTextPrimaryColor,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("sunglasses.png", width: 26, color: appStore.appTextPrimaryColor),
                                    8.width,
                                    Text(
                                      keyString(context, "lbl_free_trial")!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: fontSizeMedium,
                                        color: appStore.appTextPrimaryColor,
                                      ),
                                    )
                                  ],
                                ).visible(mSampleFile.length > 0).onTap(() {
                                  _settingModalBottomSheet(context, mDownloadFileArray, isSampleFile: true);
                                }),
                              ],
                            ).paddingOnly(left: 16, right: 16),
                            16.height,
                            Html(
                              data: mBookDetailsData.description,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(fontSizeMedium),
                                  color: appStore.textSecondaryColor,
                                ),
                              },
                            ).paddingSymmetric(horizontal: 8),
                            getAttribute().visible(isSingleSampleFile(mBookDetailsData.attributes!.length)).paddingOnly(left: 16, right: 16),
                            BookDescriptionCategoryComponent(mBookDetailsData).visible(mBookDetailsData.categories!.length > 0).paddingOnly(left: 16, right: 16),
                            16.height,
                            getAuthor(),
                            16.height,
                            AllReviewComponent(
                              mBookDetailsData,
                              mIsFreeBook,
                              appStore.isLoggedIn,
                              widget.mBookId,
                            ).visible(mBookDetailsData.reviewsAllowed!),
                            16.height,
                            MoreBookFromAuthorComponent(
                              mBookDetailsData,
                            ).visible(mBookDetailsData.upsellId!.length > 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(alignment: Alignment.center, height: context.height(), child: appLoaderWidget),
          if (mReviewIsLoading || mFetchingFile) CircularProgressIndicator().center(),
        ],
      ).paddingTop(context.statusBarHeight + 4),
      bottomNavigationBar: Container(
        height: AdSize.banner.height.toDouble(),
        child: AdWidget(
          ad: BannerAd(
            adUnitId: getBannerAdUnitId()!,
            size: AdSize.banner,
            request: AdRequest(),
            listener: BannerAdListener(),
          )..load(),
        ).visible(isAdsLoading == true),
      ),
    );
  }
}
