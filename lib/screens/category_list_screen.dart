import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/component/category_list_component.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/CategoriesListResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import 'error_view_screeen.dart';
import 'NoInternetConnection.dart';
import 'view_all_book_screen.dart';

// ignore: must_be_immutable
class CategoriesListScreen extends StatefulWidget {
  static var tag = "/CategoriesList";
  bool _isShowBack = true;

  CategoriesListScreen({isShowBack = true}) {
    _isShowBack = isShowBack;
  }

  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  var scrollController = new ScrollController();
  var mSearchCont = TextEditingController();

  bool isLastPage = false;

  List<CategoriesListResponse> mCategoriesList = [];
  List<CategoriesListResponse> mSearchList = [];

  int page = 1;
  int mPerPage = 20;

  String mSearchText = "";

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      scrollHandler();
    });
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      appStore.setLoading(true);

      await getCategoriesList(page);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    mSearchCont.dispose();
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLastPage) {
      page++;
      getCategoriesList(page);
    }
  }

  ///get category list api
  Future getCategoriesList(page) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getCatListRestApi(page, mPerPage).then((res) async {
          setState(() {
            Iterable mCategory = res;
            appStore.setLoading(false);

            mCategoriesList.addAll(mCategory.map((model) => CategoriesListResponse.fromJson(model)).toList());
            isLastPage = false;
            mSearchList = mCategoriesList;
          });
        }).catchError((onError) {
          log(onError.toString());
          setState(() {
            isLastPage = true;
          });
          appStore.setLoading(false);
        });
      } else {
        NoInternetConnection().launch(context);
        setState(() {
          isLastPage = true;
        });
        appStore.setLoading(false);
      }
    }).catchError((error) {
      log(error.toString());
      if (!mounted) return;
      setState(() {
        isLastPage = true;
      });
      appStore.setLoading(false);
      log(error.toString());
      ErrorViewScreen(message: error.toString()).launch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainView = SingleChildScrollView(
      primary: false,
      controller: scrollController,
      child: Container(
        padding: EdgeInsets.only(bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            10.height,
            searchWidget(context, controller: mSearchCont, hint: keyString(context, "lbl_search_by_categories"), onChanged: (string) {
              setState(() {
                mSearchList = mCategoriesList.where((u) => (u.name!.toLowerCase().contains(string.toLowerCase()) || u.name!.toLowerCase().contains(string.toLowerCase()))).toList();
              });
            }).visible(mCategoriesList.isNotEmpty).paddingOnly(left: 16, right: 16),
            Text(
              keyString(context, "lbl_no_data_found")!,
              style: boldTextStyle(size: 18),
            ).paddingOnly(top: 16, left: 16).visible(mSearchList.isEmpty),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CategoryListComponent(mSearchList[index]).paddingOnly(left: 16, right: 16).onTap(() {
                    ViewAllBooksScreen(
                      isCategoryBook: true,
                      categoryId: mSearchList[index].id.toString(),
                      categoryName: mSearchList[index].name,
                    ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  });
                },
                itemCount: mSearchList.length,
                shrinkWrap: true,
              ),
            ).visible(mSearchList.isNotEmpty),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar(context, title: keyString(context, "lbl_categories"), showBack: widget._isShowBack, titleSpacing: 8, fontSize: widget._isShowBack ? 16 : 28),
      backgroundColor: appStore.scaffoldBackground,
      body: RefreshIndicator(
        onRefresh: () {
          page = 1;
          mCategoriesList.clear();
          return getCategoriesList(page);
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: context.height() * 0.85,
              child: mainView,
            ).visible(mCategoriesList.isNotEmpty),
            (mCategoriesList.isNotEmpty)
                ? viewMoreDataLoader.visible(appStore.isLoading)
                : Observer(builder: (context) {
                    return appLoaderWidget.center().visible(appStore.isLoading);
                  }),
            Observer(builder: (context) {
              return noDataFound(title: keyString(context, 'lbl_no_categories_found')).center().visible(!appStore.isLoading && mCategoriesList.isEmpty);
            })
          ],
        ),
      ),
    );
  }
}
