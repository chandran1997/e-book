import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/search_view_compnent.dart';
import 'package:flutterapp/model/AllBookListResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../main.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _hasSpeech = false;

  //String lastWords = "";

  String lastError = "";
  String lastStatus = "";
  SpeechToText speech = SpeechToText();

  var searchBookController = TextEditingController();
  bool mIsLoading = false;
  bool isNoSearchResultFound = false;
  int pageNumber = 1;
  int? totalPages = 1;
  List<DashboardBookInfo>? mBookList = [];

  bool isLastPage = false;
  var scrollController = new ScrollController();
  String mSearchText = "";
  var searchHistory = <String>[];

  @override
  void initState() {
    super.initState();
    getSearchHistory();
    scrollController.addListener(() {
      scrollHandler();
    });
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener);
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void startListening() {
    mSearchText = "";
    lastError = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      mSearchText = "${result.recognizedWords}";
      addToSearchArray(mSearchText);
      getSearchHistory();
      if (searchHistory.isNotEmpty) {
        getViewAllBookData(mSearchText, isNewSearch: true);
      }
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  getSearchHistory() async {
    searchHistory = await getSearchValue();
    setState(() {});
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLastPage) {
      pageNumber++;
      if (totalPages! >= pageNumber) {
        getViewAllBookData(mSearchText);
      }
    }
  }

  ///get view all bookData
  Future getViewAllBookData(searchText, {bool isNewSearch = false}) async {
    if (isNewSearch) {
      mBookList!.clear();
      pageNumber = 1;
    }
    this.mSearchText = searchText;
    setState(() {
      mIsLoading = true;
    });
    var request = {
      'text': searchText.toString(),
      'product_per_page': books_per_page,
    };

    request.addAll({"page": pageNumber});

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getAllBookRestApi(request).then((res) {
          AllBookListResponse response = AllBookListResponse.fromJson(res);
          if (response.data!.length > 0) {
            isNoSearchResultFound = false;
            mBookList!.addAll(response.data!);
            totalPages = response.numOfPages;
          }
          setState(() {
            if (mBookList!.length == 0 && response.data!.length < 1) {
              isNoSearchResultFound = true;
            }
            mIsLoading = false;
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
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        isLastPage = true;
        setState(() {
          mIsLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        bottomSheet: Container(
          width: context.width(),
          height: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(VOLUMN_LOADER, fit: BoxFit.cover, height: 60, width: 60),
              Text(mSearchText.validate(), style: secondaryTextStyle()),
            ],
          ),
          alignment: Alignment.center,
        ).visible(speech.isListening),
        body: SingleChildScrollView(
          controller: scrollController,
          primary: false,
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    keyString(context, "lbl_search")!,
                    style: boldTextStyle(size: 28),
                  ),
                ),
                16.height,
                searchWidget(context,
                    controller: searchBookController,
                    hint: keyString(context, "lbl_search_for_books"),
                    onFieldSubmitted: (dynamic) {
                      hideKeyboard(context);
                      addToSearchArray(searchBookController.text);
                      getSearchHistory();
                      getViewAllBookData(searchBookController.text, isNewSearch: true);
                    },
                    isSearch: true,
                    textToSpeech: () {
                      startListening();
                    }),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(keyString(context, "lbl_recent_search")!, style: boldTextStyle(size: 18)),
                    GestureDetector(
                      child: Text(
                        keyString(context, "lbl_clear_all")!,
                        style: TextStyle(fontSize: fontSizeMedium, color: appStore.appTextPrimaryColor),
                      ),
                      onTap: () {
                        clearSearchHistory();
                        getSearchHistory();
                        mBookList!.clear();
                      },
                    )
                  ],
                ).visible(searchHistory.length > 0),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 1.0, // gap between lines
                  children: searchHistory
                      .map(
                        (item) => GestureDetector(
                          child: Chip(
                            backgroundColor: appStore.appColorPrimaryLightColor,
                            label: Text(item, style: TextStyle(color: PRIMARY_COLOR, fontSize: fontSizeMedium)),
                          ),
                          onTap: () {
                            hideKeyboard(context);
                            getViewAllBookData(item, isNewSearch: true);
                          },
                        ),
                      )
                      .toList()
                      .cast<Widget>(),
                ).visible(searchHistory.length > 0),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    keyString(context, "lbl_search_result_from")! + " \"" + mSearchText + "\"",
                    style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
                  ).visible(mSearchText.length > 0),
                ).visible(!mIsLoading),
                8.height,
                Container(
                  child: SearchViewComponent(mBookList: mBookList, isNoSearchResultFound: isNoSearchResultFound),
                ).visible(mBookList!.isNotEmpty),
                (mBookList!.isNotEmpty) ? Center(child: appLoaderWidget.visible(mIsLoading)) : CircularProgressIndicator().center().visible(mIsLoading),
                noDataFound(
                  title: keyString(context, 'lbl_search_for_books_enter'),
                ).withHeight(context.height() * 0.5).center().visible(searchHistory.isEmpty)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
