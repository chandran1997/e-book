import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/component/all_sub_category_component.dart';
import 'package:flutterapp/component/view_all_book_component.dart';
import 'package:flutterapp/model/AllBookListResponse.dart';
import 'package:flutterapp/model/CategoryModel.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/Strings.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import '../app_localizations.dart';
import '../main.dart';
import 'error_view_screeen.dart';
import 'NoInternetConnection.dart';
import 'book_description_screen.dart';

// ignore: must_be_immutable
class ViewAllBooksScreen extends StatefulWidget {
  bool newestBook;
  bool futureBook;
  bool youMayLikeBook;
  bool suggestionBook;
  bool isCategoryBook;
  String categoryId;
  String? categoryName;
  String? title;

  @override
  _ViewAllBooksScreenState createState() => _ViewAllBooksScreenState();

  ViewAllBooksScreen({this.newestBook = false, this.futureBook = false, this.isCategoryBook = false, this.categoryId = "", this.categoryName = "", this.suggestionBook = false, this.youMayLikeBook = false, this.title = ""});
}

class _ViewAllBooksScreenState extends State<ViewAllBooksScreen> {
  ScrollController scrollController = new ScrollController();

  //bool mIsLoading = false;
  bool isLastPage = false;

  int pageNumber = 1;
  int? totalPages = 1;

  String? title = "";
  String description = "";

  List<DashboardBookInfo> mBookList = [];
  List<CategoryModel> mCategoryModel = [];

  var newestBookRequest = {
    "newest": "newest",
    "product_per_page": books_per_page,
  };

  var youMayLikeBookRequest = {
    'special_product': 'you_may_like',
    'product_per_page': books_per_page,
  };

  var suggestionBookRequest = {
    'special_product': 'suggested_for_you',
    'product_per_page': books_per_page,
  };

  var futureBookRequest = {
    'featured': 'product_visibility',
    'product_per_page': books_per_page,
  };

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      appStore.setLoading(true);
      await getViewAllBookData();
      scrollController.addListener(() {
        scrollHandler();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLastPage) {
      pageNumber++;
      getViewAllBookData();
    }
  }

  Future getViewAllBookData() async {
    var request;
    if (widget.newestBook) {
      request = newestBookRequest;
      title = newest_books;
      description = newest_books_desc;
    } else if (widget.youMayLikeBook) {
      request = youMayLikeBookRequest;
      title = you_may_like;
      description = you_may_like_desc;
    } else if (widget.suggestionBook) {
      request = suggestionBookRequest;
      title = books_for_you;
      description = book_store_desc;
    } else if (widget.futureBook) {
      request = futureBookRequest;
      title = featured_books;
      description = featured_books_desc;
    } else if (widget.isCategoryBook) {
      var catBookRequest = {
        "category": [widget.categoryId],
        'product_per_page': books_per_page,
      };
      await fetchSubCategoryData();
      request = catBookRequest;
      title = widget.categoryName;
      description = featured_books_desc;
    }

    request.addAll({"page": pageNumber});

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getAllBookRestApi(request).then(
          (res) {
            AllBookListResponse response = AllBookListResponse.fromJson(res);
            if (response.data!.length > 0) {
              mBookList.addAll(response.data!);
              isLastPage = false;
              totalPages = response.numOfPages;
            } else {
              isLastPage = true;
            }
            appStore.setLoading(false);
          },
        ).catchError((onError) {
          appStore.setLoading(false);
          log(onError.toString());
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        isLastPage = true;
      });
      appStore.setLoading(false);
    });
  }

  Future fetchSubCategoryData() async {
    appStore.setLoading(true);
    await getSubCategories(widget.categoryId).then((res) {
      if (!mounted) return;
      setState(() {
        Iterable mCategory = res;
        mCategoryModel = mCategory.map((model) => CategoryModel.fromJson(model)).toList();
      });
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: widget.title == "" ? title : widget.title),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AllSubCategoryComponent(mCategoryModel: mCategoryModel).visible(mCategoryModel.isNotEmpty),
                  AnimationLimiter(
                    child: ListView.separated(
                        padding: EdgeInsets.all(0),
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey.withOpacity(0.3),
                            height: 0,
                          );
                        },
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        itemCount: mBookList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];

                          DashboardBookInfo mData = mBookList[index];
                          var categoryName;
                          mData.categories.validate().forEach((element) {
                            categoryName = element.name;
                          });
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: 900.milliseconds,
                            child: SelectedAnimationType(
                              scale: 5,
                              curves: getIntAsync(ANIMATION_TYPE_SELECTION_INDEX) == SLIDE_ANIMATION ? Curves.decelerate : Curves.fastLinearToSlowEaseIn,
                              child: ViewAllBookComponent(bookData: mData, categoryName: categoryName).paddingOnly(left: 16, right: 16, top: 16, bottom: 16).onTap(() {
                                BookDescriptionScreen(mBookList[index].id.toString(), bgColor: bgColor).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                              }),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ).visible(mBookList.isNotEmpty),
            Text(keyString(context, "lbl_no_data_found")!, style: boldTextStyle()).center().visible(mBookList.isEmpty && !appStore.isLoading),
            (mBookList.isNotEmpty) ? Align(alignment: Alignment.bottomCenter, child: viewMoreDataLoader.visible(appStore.isLoading)) : Center(child: appLoaderWidget.center().visible(appStore.isLoading)),
          ],
        );
      }),
    );
  }
}
