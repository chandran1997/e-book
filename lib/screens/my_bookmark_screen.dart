import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/component/bookmark_list_component.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/BookmarkResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import 'NoInternetConnection.dart';
import 'book_description_screen.dart';

class MyBookMarkScreen extends StatefulWidget {
  static var tag = "/MyBookMarkScreen";

  @override
  _MyBookMarkScreenState createState() => _MyBookMarkScreenState();
}

class _MyBookMarkScreenState extends State<MyBookMarkScreen> {
  bool mIsLoading = false;
  List<BookmarkResponse> mBookList = [];

  @override
  void initState() {
    super.initState();
    getBookmarkBooks();
  }

  Future getBookmarkBooks() async {
    setState(() {
      mIsLoading = true;
    });

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getBookmarkRestApi().then((res) async {
          Iterable mCategory = res;
          mBookList.clear();
          mBookList = mCategory.map((model) => BookmarkResponse.fromJson(model)).toList();
          setState(() {
            mIsLoading = false;
          });
        }).catchError((onError) {
          setState(() {
            mIsLoading = false;
            mBookList.clear();
          });
          log('error : ${onError.toString()}');
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
  Widget build(BuildContext context) {
    Widget mainView = (mBookList.length < 1)
        ? bookNotAvailableWidget(context, title: keyString(context, "lbl_you_don_t_have_a_bookmark")!, buttonTitle: keyString(context, "lbl_bookmark_now")).center()
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimationLimiter(
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Color borderColor = bookBackgroundColor[index % bookBackgroundColor.length];
                        return GestureDetector(
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: 900.milliseconds,
                            child: SelectedAnimationType(
                              scale: 5,
                              curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.decelerate : Curves.fastLinearToSlowEaseIn,
                              child: BookMarkListComponent(mBookList[index], borderColor: borderColor).paddingOnly(top: 8, bottom: 8),
                            ),
                          ),
                          onTap: () async {
                            await BookDescriptionScreen(mBookList[index].proId.toString(), bgColor: borderColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            getBookmarkBooks();
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey.withOpacity(0.3));
                      },
                      itemCount: mBookList.length),
                ),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 16),
          );

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, showTitle: true, title: keyString(context, 'lbl_my_bookmark')),
      body: Stack(children: [
        (!mIsLoading) ? mainView : appLoaderWidget.center().visible(mIsLoading),
      ]),
    );
  }
}
