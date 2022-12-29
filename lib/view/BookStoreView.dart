import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/bookstore_slider_component.dart';
import 'package:flutterapp/component/categorywise_book_component.dart';
import 'package:flutterapp/component/featured_book_component.dart';
import 'package:flutterapp/component/featured_view_all_component.dart';
import 'package:flutterapp/component/new_book_all_component.dart';
import 'package:flutterapp/component/new_book_component.dart';
import 'package:flutterapp/component/suggested_book_component.dart';
import 'package:flutterapp/component/suggested_view_all_component.dart';
import 'package:flutterapp/component/you_like_book_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/HeaderModel.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ProfileView.dart';

class BookStoreView extends StatefulWidget {
  static String tag = '/BookStoreView';

  @override
  _BookStoreViewState createState() => _BookStoreViewState();
}

class _BookStoreViewState extends State<BookStoreView> {
  List<DashboardBookInfo> mNewestBookModel = [];
  List<DashboardBookInfo> mFeaturedBookModel = [];
  List<DashboardBookInfo> mSuggestedBooksModel = [];
  List<DashboardBookInfo> mYouMayLikeBooksModel = [];
  List<Category> mCategoryList = [];
  List<HeaderModel> mHeaderModel = [];

  @override
  void initState() {
    setStatusBarColor(appStore.scaffoldBackground!);
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      appStore.setLoading(true);

      await getDashboardData();
    });
  }

  String parseHtmlString(String? htmlString) {
    return parse(parse(htmlString).body!.text).documentElement!.text;
  }

  /// Get Dashboard data from server
  Future getDashboardData() async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getDashboardDataRestApi().then((res) {
          DashboardResponse dashboardResponse = DashboardResponse.fromJson(res);

          if (dashboardResponse.socialLink != null) {
            setValue(WHATSAPP, dashboardResponse.socialLink!.whatsapp);
            setValue(FACEBOOK, dashboardResponse.socialLink!.facebook);
            setValue(TWITTER, dashboardResponse.socialLink!.twitter);
            setValue(INSTAGRAM, dashboardResponse.socialLink!.instagram);
            setValue(CONTACT, dashboardResponse.socialLink!.contact);
            setValue(PRIVACY_POLICY, dashboardResponse.socialLink!.privacyPolicy);
            setValue(TERMS_AND_CONDITIONS, dashboardResponse.socialLink!.termCondition);
            setValue(COPYRIGHT_TEXT, dashboardResponse.socialLink!.copyrightText);
          }

          setValue(CURRENCY_SYMBOL, parseHtmlString(dashboardResponse.currencySymbol!.currencySymbol));
          setValue(CURRENCY_NAME, dashboardResponse.currencySymbol!.currency!);

          setValue(PAYMENT_METHOD, dashboardResponse.paymentMethod);
          setValue(LANGUAGE, dashboardResponse.appLang!);
          appStore.setLanguage(dashboardResponse.appLang!);

          appStore.checkRTL(value: dashboardResponse.appLang);
          mNewestBookModel.clear();
          mFeaturedBookModel.clear();
          mSuggestedBooksModel.clear();
          mYouMayLikeBooksModel.clear();
          mHeaderModel.clear();
          mCategoryList.clear();
          mNewestBookModel.addAll(dashboardResponse.newest!);
          mFeaturedBookModel.addAll(dashboardResponse.featured!);
          mSuggestedBooksModel.addAll(dashboardResponse.suggestedForYou!);
          mYouMayLikeBooksModel.addAll(dashboardResponse.youMayLike!);

          for (var i = 0; i < dashboardResponse.category!.length; i++) {
            if (dashboardResponse.category![i].product!.length > 0) {
              mCategoryList.add(dashboardResponse.category![i]);
            }
          }

          createHeaderData(mNewestBookModel, keyString(context, "header_newest_book_title"), keyString(context, "header_newest_book_message"), BOOK_TYPE_NEW);
          createHeaderData(mFeaturedBookModel, keyString(context, "header_featured_book_title"), keyString(context, "header_featured_book_message"), BOOK_TYPE_FEATURED);
          createHeaderData(mSuggestedBooksModel, keyString(context, "header_for_you_book_title"), keyString(context, "header_for_you_book_message"), BOOK_TYPE_SUGGESTION);
          createHeaderData(mYouMayLikeBooksModel, keyString(context, "header_like_book_title"), keyString(context, "header_like_book_message"), BOOK_TYPE_LIKE);

          appStore.setLoading(false);
        }).catchError((onError) {
          if (!mounted) return;

          appStore.setLoading(false);
          print(onError.toString());

          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        NoInternetConnection(isCloseApp: true).launch(context);
      }
    });
  }

  createHeaderData(bookModel, title, message, type) async {
    if (bookModel.length > 0) {
      String image1 = "";
      String image2 = "";
      if (bookModel[0].images != null) {
        image1 = bookModel[0].images[0].src.toString();
      }
      if (bookModel.length > 1) {
        if (bookModel[1].images != null) {
          image2 = bookModel[1].images[0].src.toString();
        } else {
          image2 = image1;
        }
      } else {
        image2 = image1;
      }
      mHeaderModel.add(HeaderModel(title, message, image1, image2, type));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        body: RefreshIndicator(
          onRefresh: () {
            return getDashboardData();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 40,
                      floating: false,
                      pinned: true,
                      titleSpacing: 16,
                      forceElevated: innerBoxIsScrolled,
                      elevation: 1,
                      automaticallyImplyLeading: false,
                      backgroundColor: innerBoxIsScrolled ? appStore.scaffoldBackground : appStore.scaffoldBackground,
                      actions: [
                        appStore.profileImage.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(appStore.profileImage),
                                radius: context.width() * 0.05,
                              ).paddingOnly(right: 16).onTap(() {
                                ProfileView().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                              })
                            : IconButton(
                                onPressed: () {
                                  ProfileView().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                },
                                icon: Image.asset('assets/profile_icon.png', color: appStore.iconColor, height: 24, width: 24),
                              )
                      ],
                      title: Text(
                        keyString(context, "lbl_hello")! + ' ' + (appStore.firstName.isEmpty ? keyString(context, "lbl_guest")! : appStore.firstName),
                        style: boldTextStyle(color: appStore.appTextPrimaryColor),
                      ).visible(mNewestBookModel.isNotEmpty && innerBoxIsScrolled),
                    )
                  ];
                },
                body: SingleChildScrollView(
                  child: Container(
                    color: appStore.scaffoldBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleSilverAppBarWidget(context, title1: keyString(context, "lbl_hello")!, title2: appStore.firstName.isEmpty ? keyString(context, "lbl_guest")! : appStore.firstName, isHome: true),
                            16.height,
                            Text(
                              keyString(context, "book_store_desc")!,
                              style: boldTextStyle(size: 20),
                            ).visible(mNewestBookModel.isNotEmpty).paddingLeft(16),
                            16.height,
                            BookStoreSliderComponent(mHeaderModel: mHeaderModel).visible(mHeaderModel.isNotEmpty),
                            CategoryWiseBookComponent(mCategoryList: mCategoryList).visible(mCategoryList.isNotEmpty),
                            16.height,
                            NewBookAllComponent(mNewestBookModel: mNewestBookModel),
                            NewBookComponent(mNewestBookModel: mNewestBookModel).visible(mNewestBookModel.isNotEmpty),
                            16.height,
                            FeaturedViewAllComponent(mFeaturedBookModel: mFeaturedBookModel).visible(mFeaturedBookModel.isNotEmpty),
                            FeaturedBookComponent(mFeaturedBookModel: mFeaturedBookModel).visible(mFeaturedBookModel.isNotEmpty),
                            16.height.visible(mSuggestedBooksModel.isNotEmpty),
                            SuggestedViewAllComponent(mSuggestedBooksModel: mSuggestedBooksModel).visible(mSuggestedBooksModel.isNotEmpty),
                            SuggestedBookComponent(mSuggestedBooksModel: mSuggestedBooksModel).visible(mSuggestedBooksModel.isNotEmpty),
                            GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(top: 16, left: 16, right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 40,
                                        child: Text(
                                          keyString(context, "you_may_like")!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: appStore.iconColor,
                                          size: 30.0,
                                          textDirection: appStore.isRTL ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  ViewAllBooksScreen(
                                    title: keyString(context, "you_may_like"),
                                    youMayLikeBook: true,
                                  ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                }).visible(mYouMayLikeBooksModel.isNotEmpty),
                            YouLikeBookComponent(mYouMayLikeBooksModel: mYouMayLikeBooksModel).visible(mYouMayLikeBooksModel.isNotEmpty),
                            16.height,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Observer(builder: (context) {
                return appLoaderWidget.center().visible(appStore.isLoading);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
