import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/author_details_component.dart';
import 'package:flutterapp/component/author_details_header_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/admob_utils.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/images.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NoInternetConnection.dart';
import 'book_description_screen.dart';
import 'error_view_screeen.dart';

// ignore: must_be_immutable
class AuthorDetails extends StatefulWidget {
  final AuthorListResponse? authorDetails;
  final AuthorResponse? authorDetails1;
  final bool? isDetail;
  String? url;
  String? fullName;
  Color? bgColor;

  AuthorDetails(this.url, this.fullName, {this.authorDetails, this.authorDetails1, this.isDetail = false, this.bgColor});

  @override
  _AuthorDetailsState createState() => _AuthorDetailsState();
}

class _AuthorDetailsState extends State<AuthorDetails> {
  List<DashboardBookInfo>? mAuthorBookList;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(widget.bgColor ?? Colors.transparent);
      appStore.setLoading(true);
      getAuthorList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(appStore.scaffoldBackground!);
  }

  ///get author list api call
  Future getAuthorList() async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getAuthorBookListRestApi(widget.isDetail == true ? widget.authorDetails1!.id : widget.authorDetails!.id).then(
          (res) async {
            appStore.setLoading(false);
            Iterable mCategory = res;
            mAuthorBookList = mCategory.map((model) => DashboardBookInfo.fromJson(model)).toList();
            setState(() {});
          },
        ).catchError(
          (onError) {
            appStore.setLoading(false);
            ErrorViewScreen(message: onError.toString()).launch(context);
          },
        );
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget blankView = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(spacing_standard_30),
            child: Image.asset(ic_book_logo, width: 150),
          ),
          Text(keyString(context, 'lbl_book_not_available')!, style: boldTextStyle(size: 20)),
          8.height,
        ],
      ),
    );
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                expandedHeight: context.height() * 0.38,
                floating: true,
                pinned: true,
                titleSpacing: 0,
                backgroundColor: innerBoxIsScrolled ? widget.bgColor : widget.bgColor,
                iconTheme: IconThemeData(color: Colors.white),
                forceElevated: innerBoxIsScrolled,
                title: Text(
                  widget.fullName!.validate(),
                  style: boldTextStyle(size: 20, color: white),
                ).visible(widget.fullName!.isNotEmpty && innerBoxIsScrolled),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: AuthorDetailsHeaderComponent(
                    authorDetails: widget.authorDetails,
                    fullName: widget.fullName.validate(),
                    url: widget.url.validate(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: <Widget>[
            (mAuthorBookList != null)
                ? mAuthorBookList!.isEmpty
                    ? blankView
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text('${widget.authorDetails!.description!}', style: primaryTextStyle(), maxLines: 10),
                          ).paddingOnly(left: 16, right: 16, top: 16).visible(widget.authorDetails!.description!.validate().isNotEmpty),
                          16.height.visible(widget.authorDetails!.description!.validate().isNotEmpty),
                          16.height,
                          AnimationLimiter(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(color: Colors.grey.withOpacity(0.3), height: 0);
                              },
                              padding: EdgeInsets.all(0),
                              itemCount: mAuthorBookList!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: 600.milliseconds,
                                  child: SelectedAnimationType(
                                    duration: Duration(milliseconds: 700),
                                    scale: 2.0,
                                    curves: Curves.linear,
                                    child: AuthorDetailsComponent(
                                      bookData: mAuthorBookList![index],
                                      bgColor: bgColor,
                                    ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8).onTap(() {
                                      BookDescriptionScreen(
                                        mAuthorBookList![index].id.toString(),
                                        bgColor: bgColor,
                                      ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                    }),
                                  ),
                                );
                                //return AuthorDetailsComponent();
                              },
                            ).expand(),
                          )
                        ],
                      )
                : Observer(builder: (context) {
                    return appLoaderWidget.center().visible(appStore.isLoading);
                  }),
          ],
        ).paddingTop(context.height() * 0.1),
      ),
      bottomNavigationBar: Container(
        height: AdSize.banner.height.toDouble(),
        child: AdWidget(
          ad: BannerAd(
            adUnitId: getBannerAdUnitId()!,
            size: AdSize.banner,
            request: AdRequest(),
            listener: BannerAdListener(),
          )..load(),
        ),
      ).visible(isAdsLoading == true),
    );
  }
}
