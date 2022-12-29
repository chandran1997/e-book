import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/review_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/ReviewResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import 'error_view_screeen.dart';

// ignore: must_be_immutable
class ReviewScreen extends StatefulWidget {
  static var tag = "/ViewAllReviewScreen";

  int? mBookId;

  ReviewScreen(this.mBookId);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<DashboardBookInfo> product = [];
  List<ReviewResponse> mReviewList = [];

  bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(appStore.scaffoldBackground!);
    fetchData();
  }

  ///review list api call
  Future fetchData() async {
    mIsLoading = true;
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getProductReviews(widget.mBookId).then((res) {
          if (!mounted) return;
          setState(() {
            mIsLoading = false;
            Iterable list = res;
            mReviewList = list.map((model) => ReviewResponse.fromJson(model)).toList();
          });
        }).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          mIsLoading = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.grey.shade300);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.scaffoldBackground!);

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, "lbl_review")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          (!mIsLoading)
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      if (mReviewList.length < 1)
                        noDataFoundWidget(context, title: keyString(context, 'lbl_no_review_found')!)
                      else
                        AnimationLimiter(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: mReviewList.length,
                            padding: EdgeInsets.only(bottom: 16),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ReviewResponse reviewData = mReviewList[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: 600.milliseconds,
                                child: SelectedAnimationType(
                                  scale: 4,
                                  curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.fastLinearToSlowEaseIn : Curves.decelerate,
                                  child: ReviewComponent(reviewData: reviewData),
                                ),
                              );
                            },
                            shrinkWrap: true,
                          ),
                        ),
                    ],
                  ),
                )
              : appLoaderWidget.center().visible(mIsLoading),
        ],
      ),
    );
  }
}
