import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/author_list_component.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'NoInternetConnection.dart';
import 'author_details.dart';
import 'error_view_screeen.dart';

class AuthorListScreen extends StatefulWidget {
  static var tag = "/AuthorList";

  @override
  _AuthorListScreenState createState() => _AuthorListScreenState();
}

class _AuthorListScreenState extends State<AuthorListScreen> {
  var mSearchCont = TextEditingController();
  var scrollController = new ScrollController();

  List<AuthorListResponse> mAuthorList = [];
  List<AuthorListResponse> mSearchList = [];

  String mSearchText = "";

  int page = 1;
  int mPerPage = 20;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      getAuthorList(page);
    });
    scrollController.addListener(() {
      scrollHandler();
    });
  }

  @override
  void dispose() {
    mSearchCont.dispose();
    scrollController.dispose();

    super.dispose();
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      page++;
      getAuthorList(page);
    }
  }

  ///get author list api call
  Future getAuthorList(page) async {
    appStore.setLoading(true);
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getAuthorListRestApi(page, mPerPage).then((res) async {
          appStore.setLoading(false);
          mAuthorList.addAll(res);
          mSearchList = mAuthorList;

          setState(() {});
        }).catchError((onError) {
          appStore.setLoading(false);
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        appStore.setLoading(false);

        NoInternetConnection().launch(context);
      }
    });
  }

  String? getAuthorName(authorListResponse) {
    return authorListResponse.firstName + " " + authorListResponse.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, "lbl_author")),
      body: RefreshIndicator(
        onRefresh: () {
          page = 1;
          mAuthorList.clear();

          return getAuthorList(page);
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              primary: false,
              controller: scrollController,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    searchWidget(context, controller: mSearchCont, hint: keyString(context, "lbl_search_by_author_name"), onChanged: (string) {
                      setState(() {
                        mSearchList = mAuthorList.where((u) => (u.firstName!.toLowerCase().contains(string.toLowerCase()) || u.firstName!.toLowerCase().contains(string.toLowerCase()))).toList();
                      });
                    }).paddingOnly(left: 16, right: 16),
                    Text(
                      keyString(context, "lbl_no_data_found")!,
                      style: boldTextStyle(size: 18),
                    ).paddingOnly(top: 16, left: 16).visible(mSearchList.isEmpty),
                    AnimationLimiter(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Color bgColor = authorBorderColor[index % authorBorderColor.length];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: 600.milliseconds,
                            columnCount: 1,
                            child: SelectedAnimationType(scale: 3, curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.easeOut : Curves.easeOutBack, child: AuthorListComponent(mSearchList[index], bgColor)).onTap(() {
                              AuthorDetails(
                                mSearchList[index].gravatar.validate(),
                                getAuthorName(mSearchList[index]),
                                authorDetails: mSearchList[index],
                                bgColor: bgColor,
                              ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            }),
                          );
                        },
                        itemCount: mSearchList.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              ).visible(mAuthorList.isNotEmpty),
            ),
            Observer(builder: (context) {
              return CircularProgressIndicator().center().visible(appStore.isLoading && page > 1);
            }),
            Observer(builder: (context) {
              return Center(child: appLoaderWidget.center().visible(appStore.isLoading && page == 1));
            }),
          ],
        ),
      ),
    );
  }
}
