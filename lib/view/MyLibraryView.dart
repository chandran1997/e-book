import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/free_book_list_component.dart';
import 'package:flutterapp/component/purchase_book_list_component.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/model/OfflineBookList.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/database_helper.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class MyLibraryView extends StatefulWidget {
  @override
  _MyLibraryViewState createState() => _MyLibraryViewState();
}

class _MyLibraryViewState extends State<MyLibraryView> {
  bool mIsLoading = false;
  var mOrderList = <BookPurchaseResponse>[];
  var mBookList = <LineItems>[];
  int? _sliding = 0;
  final dbHelper = DatabaseHelper.instance;
  var downloadedList = <OfflineBookList>[];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getBookmarkBooks();
    await fetchData(context);
    LiveStream().on(REFRESH_LIST, (p0) async {
      fetchData(context);
      await getBookmarkBooks();
    });
    LiveStream().on(REFRESH_LIBRARY_DATA, (p0) async {
      await fetchData(context);
      await getBookmarkBooks();
    });
  }

  Future<void> fetchData(context) async {
    List<OfflineBookList>? books = await (dbHelper.queryAllRows(appStore.userId));

    if (books!.isNotEmpty) {
      downloadedList.clear();
      downloadedList.addAll(books);

      setState(() {});
    } else {
      setState(() {
        downloadedList.clear();
      });
    }
  }

  ///remove book
  Future<void> remove(OfflineBookList task) async {
    Future.forEach(task.offlineBook, (OfflineBook e) async {
      if (File(e.filePath!).existsSync()) {
        await dbHelper.delete(e.filePath!);
        await File(e.filePath!).delete();
        await fetchData(context);
      } else {
        log("book not exits");
      }
    });
  }

  Future getBookmarkBooks() async {
    setState(() {
      mIsLoading = true;
    });

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getPurchasedRestApi().then((res) async {
          Iterable order = res;
          mOrderList = order.map((model) => BookPurchaseResponse.fromJson(model)).toList();
          mBookList.clear();
          setValue(LIBRARY_DATA, jsonEncode(res));

          for (var i = 0; i < mOrderList.length; i++) {
            if (mOrderList[i].lineItems!.length > 0) {
              mBookList.addAll(mOrderList[i].lineItems!);
            }
          }
          setState(() {
            mIsLoading = false;
          });
        }).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
          log(onError.toString());
          if (getBoolAsync(TOKEN_EXPIRED) == true) {
            getBookmarkBooks();
          } else {
            ErrorViewScreen(message: onError.toString()).launch(context);
          }
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SafeArea(
        child: Scaffold(
          backgroundColor: appStore.scaffoldBackground,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: Container(
              width: context.width(),
              padding: EdgeInsets.all(16.0),
              child: CupertinoSlidingSegmentedControl(
                children: {
                  0: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      keyString(context, "lbl_purchased_book")!,
                      style: primaryTextStyle(color: _sliding == 0 ? PRIMARY_COLOR : appStore.appTextPrimaryColor),
                    ),
                  ),
                  1: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      keyString(context, "lbl_free_book")!,
                      style: primaryTextStyle(color: _sliding == 1 ? PRIMARY_COLOR : appStore.appTextPrimaryColor),
                    ),
                  ),
                },
                groupValue: _sliding,
                onValueChanged: (dynamic newValue) {
                  setState(() {
                    _sliding = newValue;
                  });
                },
              ),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              (!mIsLoading)
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        if (_sliding == 0) PurchaseBookListComponent(mBookList: mBookList),
                        if (_sliding == 1)
                          FreeBookListComponent(
                            downloadedList: downloadedList,
                            onRemoveBookUpdate: (OfflineBookList bookDetail) {
                              remove(bookDetail);
                            },
                          ),
                      ],
                    )
                  : appLoaderWidget.center().visible(mIsLoading),
            ],
          ),
        ),
      ),
    );
  }
}
