import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/component/book_item_rounded_component.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/admob_utils.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/images.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';
import 'error_view_screeen.dart';
import 'NoInternetConnection.dart';
import 'book_description_screen.dart';

// ignore: must_be_immutable
class AuthorWiseBookScreen extends StatefulWidget {
  final AuthorListResponse? authorDetails;
  final AuthorResponse? authorDetails1;
  final bool? isDetail;
  String? url;
  String? fullName;

  AuthorWiseBookScreen(this.url, this.fullName, {this.authorDetails, this.authorDetails1, this.isDetail = false});

  @override
  _AuthorWiseBookScreenState createState() => _AuthorWiseBookScreenState();
}

class _AuthorWiseBookScreenState extends State<AuthorWiseBookScreen> {
  List<DashboardBookInfo>? mAuthorBookList;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.isDarkModeOn ? setStatusBarColor(appStore.isLoading ? appStore.scaffoldBackground! : appStore.scaffoldBackground!) : setStatusBarColor(appStore.isLoading ? appStore.scaffoldBackground! : Colors.grey.shade300);
    });
    getAuthorList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///author list api call
  Future getAuthorList() async {
    appStore.setLoading(true);
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

            ErrorViewScreen(
              message: onError.toString(),
            ).launch(context);
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
          10.height,
        ],
      ),
    );
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: appStore.appBarColor,
        elevation: 0,
        title: Row(
          children: [
            CachedNetworkImage(
              height: 40,
              width: 40,
              placeholder: (context, url) => Center(
                child: bookLoaderWidget,
              ),
              imageUrl: widget.url.validate(),
              fit: BoxFit.fill,
            ).cornerRadiusWithClipRRect(40),
            8.width,
            Text(widget.fullName!.validate(), style: boldTextStyle(size: 20)),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          (mAuthorBookList != null)
              ? mAuthorBookList!.isEmpty
                  ? blankView
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 26,
                        runSpacing: 16,
                        children: mAuthorBookList.validate().map((e) {
                          int index = mAuthorBookList.validate().indexOf(e);

                          Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                          return GestureDetector(
                            child: BookItemRoundedWidget(
                              bookData: mAuthorBookList![index],
                              bgColor: bgColor,
                            ),
                            onTap: () {
                              BookDescriptionScreen(mAuthorBookList![index].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            },
                          );
                        }).toList(),
                      ).center(),
                    )
              : Observer(builder: (context) {
                  return appLoaderWidget.center().visible(appStore.isLoading);
                }),
        ],
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
        ).visible(isAdsLoading == true),
      ),
    );
  }
}
