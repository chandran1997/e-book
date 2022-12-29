import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/adapterView/DownloadFilesView.dart';
import 'package:flutterapp/component/PaymentSheetComponent.dart';
import 'package:flutterapp/component/book_description_component.dart';
import 'package:flutterapp/component/bookdescription_top_widget.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/model/PaidBookResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/admob_utils.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import 'NoInternetConnection.dart';
import 'error_view_screeen.dart';
import 'my_cart_screen.dart';
import 'sign_in_screen.dart';

class BookDescriptionScreen extends StatefulWidget {
  static String tag = '/BookDescriptionScreen';
  var mBookId = "0";
  final Color? bgColor;

  BookDescriptionScreen(this.mBookId, {this.bgColor});

  @override
  BookDescriptionScreenState createState() => BookDescriptionScreenState();
}

class BookDescriptionScreenState extends State<BookDescriptionScreen> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  double? scrollPosition = 0.0;

  DashboardBookInfo? mBookDetailsData;
  var mSampleFile = "";
  var mTotalAmount = "";

  List<DownloadModel> mDownloadFileArray = [];
  List<DownloadModel> mDownloadPaidFileArray = [];
  List<DashboardBookInfo> mBookDetailsList = [];

  // var myCartList = <MyCartResponse>[];

  InterstitialAd? interstitialAd;

  bool mReviewIsLoading = false;
  bool mFetchingFile = false;
  bool mIsFreeBook = false;
  bool mIsLoading = false;

  _scrollListener() {
    setState(() {
      scrollPosition = _scrollController!.position.pixels;
      print(_scrollController!.position.pixels);
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    afterBuildCreated(() {
      setState(() {
        mIsLoading = true;
      });
      setState(() {
        mIsLoading = true;
      });
      init();
    });
    super.initState();
  }

  init() async {
    setState(() {
      mIsLoading = true;
    });

    createInterstitialAd();
    setState(() {});
    getBookDetails();

    LiveStream().on(REFRESH_REVIEW_LIST, (p0) async {
      await getBookDetails();
    });

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

  /// Book Detail API call
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
          if (afterPayment) {
            mFetchingFile = false;
          } else {
            setState(() {
              mIsLoading = false;
            });
          }

          mBookDetailsList = res;
          mBookDetailsData = mBookDetailsList[0];

          if (mBookDetailsData!.type == "variable" || mBookDetailsData!.type == "grouped" || mBookDetailsData!.type == "external") {
            toastLong("Book type not supported");
            Navigator.of(context).pop();
          }

          /*if((mBookDetailsData!.price == "" && mBookDetailsData!.price!="0") || (mBookDetailsData!.salePrice == "" && mBookDetailsData!.salePrice != "0") ||(mBookDetailsData!.regularPrice == "" && mBookDetailsData!.regularPrice != "0")){
            mIsFreeBook = true;
          }else{
            mIsFreeBook = false;
          }*/

          if ((mBookDetailsData!.price.toString().isEmpty || mBookDetailsData!.price.toString() == "0") &&
                  (mBookDetailsData!.salePrice.toString().isEmpty || mBookDetailsData!.salePrice.toString() == "0") &&
                  mBookDetailsData!.regularPrice.toString().isEmpty ||
              mBookDetailsData!.regularPrice.toString() == "0") {
            mIsFreeBook = true;
          } else {
            mIsFreeBook = false;
          }

          getBookPrice();

          // Get sample files url
          mDownloadFileArray.clear();
          mSampleFile = "";
          for (var i = 0; i < mBookDetailsData!.attributes!.length; i++) {
            if (mBookDetailsData!.attributes![i].name == SAMPLE_FILE) {
              if (mBookDetailsData!.attributes![i].options!.length > 0) {
                mSampleFile = "ContainsDownloadFiles";
                var dv = DownloadModel();
                dv.id = "1";
                dv.name = "Sample File";
                dv.file = mBookDetailsData!.attributes![i].options![0].toString();
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
              setState(() {
                mIsLoading = false;
              });
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
            setState(() {
              mIsLoading = false;
            });
          }
        });

        NoInternetConnection().launch(context);
      }
    });
  }

  ///get paid file details
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

  ///get Additional Information
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
    if (mBookDetailsData!.onSale!) {
      mTotalAmount = mTotalAmount + mBookDetailsData!.salePrice;
    } else {
      mTotalAmount = mTotalAmount + mBookDetailsData!.regularPrice;
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
                      margin: EdgeInsets.only(top: spacing_standard_new),
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
                Container(margin: EdgeInsets.only(top: spacing_standard_new), height: 2, color: lightGrayColor),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DownloadFilesView(
                        widget.mBookId,
                        viewFiles[index],
                        mBookDetailsData!.images![0].src,
                        mBookDetailsData!.name,
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

  /// Add to cart api call
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
            SnackBar(content: Text(keyString(context, 'lbl_added_to_cart')!)),
          );
          getCartItem();
          appStore.addCartCount(widget.mBookId);
          appStore.setAddToCart(true);
          setState(() {
            mReviewIsLoading = false;
          });
        }).catchError((onError) {
          log(onError.toString());
          setState(() {
            mReviewIsLoading = false;
          });
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  ///get cart item api call
  Future<void> getCartItem() async {
    await getCartBook().then((value) {
      Iterable mCart = value;
      myCartList.clear();
      myCartList = mCart.map((e) {
        return MyCartResponse.fromJson(e);
      }).toList();
      myCartList.forEach((element) {
        if (element.proId.validate() == widget.mBookId.toInt()) {
          appStore.setAddToCart(true);
        }
      });
      setState(() {
        mIsLoading = false;
      });
      setState(() {});
    }).catchError((onError) {
      log(onError.toString());
      setState(() {
        mIsLoading = false;
      });
    });
  }

  ///remove cart api call
  Future<void> removeFromCart() async {
    appStore.setLoading(true);

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

  ///Buy
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
            onCall: () {
              setState(() {
                finish(mContext);
                removeFromCart();
                getCartItem();
                getBookDetails(afterPayment: true);
              });
            },
          );
          //
        });
      },
    );
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
    setStatusBarColor(appStore.scaffoldBackground!);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.isDarkModeOn ? setStatusBarColor(mIsLoading ? appStore.scaffoldBackground! : appStore.scaffoldBackground!) : setStatusBarColor(mIsLoading ? appStore.scaffoldBackground! : Colors.grey.shade300);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        body: Observer(builder: (context) {
          return Stack(
            children: [
              AnimatedCrossFade(
                  firstChild: CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 260.0,
                        titleSpacing: 0,
                        floating: false,
                        collapsedHeight: kToolbarHeight,
                        pinned: true,
                        elevation: 0,
                        backgroundColor: appStore.isDarkModeOn ? appStore.appColorPrimaryLightColor : Colors.grey.shade300,
                        leading: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.keyboard_backspace_outlined, color: appStore.iconColor),
                              onPressed: () {
                                finish(context);
                              },
                            ),
                          ],
                        ),
                        actions: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              IconButton(
                                padding: EdgeInsets.only(right: 0, top: 12),
                                onPressed: () async {
                                  if (appStore.isLoggedIn) {
                                    Map? res = await MyCartScreen(isDescription: true).launch(context);
                                    log(res);
                                    if (res != null) {
                                      await getBookDetails(afterPayment: true);
                                      await getCartItem();
                                    }
                                  } else {
                                    SignInScreen().launch(context);
                                  }
                                },
                                icon: Icon(Icons.shopping_cart_outlined, color: appStore.iconColor),
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
                        ],
                        flexibleSpace: mBookDetailsData != null
                            ? BookDescriptionTopWidget(
                                mBookDetailsData: mBookDetailsData,
                                bgColor: widget.bgColor,
                                scrollPosition: scrollPosition,
                                mIsFreeBook: mIsFreeBook,
                                mDownloadPaidFileArray: mDownloadPaidFileArray,
                                mBookId: widget.mBookId,
                                onUpdateBuyNow: () {
                                  appStore.isLoggedIn ? buyNow() : SignInScreen().launch(context);
                                },
                                onUpdate: () async {
                                  getPaidFileDetails();
                                },
                                onAddToCartUpdate: () async {
                                  appStore.isLoggedIn
                                      ? myCartList.any((e) => e.proId.toString() == widget.mBookId)
                                          ? MyCartScreen().launch(context)
                                          : addToCard()
                                      : SignInScreen().launch(context);
                                },
                              )
                            : SizedBox(),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            mBookDetailsData != null
                                ? BookDescriptionComponent(
                                    mBookDetailsData: mBookDetailsData,
                                    mIsFreeBook: mIsFreeBook,
                                    mBookId: widget.mBookId,
                                    myCartList: myCartList,
                                    mSampleFile: mSampleFile,
                                    mDownloadFileArray: mDownloadFileArray,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      /* SliverFillRemaining(
                            hasScrollBody: false,
                            child: BookDescriptionComponent(
                                mBookDetailsData: mBookDetailsData,
                                mIsFreeBook: mIsFreeBook,
                                mBookId: widget.mBookId,
                                myCartList: myCartList,
                                mSampleFile: mSampleFile,
                                mDownloadFileArray: mDownloadFileArray)),*/
                    ],
                  ),
                  secondChild: Container(alignment: Alignment.center, height: context.height(), child: appLoaderWidget),
                  crossFadeState: (mBookDetailsData != null && !mIsLoading) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: 2.seconds),
              if (mReviewIsLoading || mFetchingFile) CircularProgressIndicator().center(),
            ],
          );
        }),
      ),
    );
  }
}
