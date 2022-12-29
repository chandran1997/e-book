import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/utils.dart';

// ignore: must_be_immutable
class PDFScreen extends StatefulWidget {
  static String tag = '/PDFScreen';
  String? mBookId, mBookPath, mTitle;

  PDFScreen(this.mBookId, this.mBookPath, this.mTitle);

  @override
  PDFScreenState createState() => PDFScreenState();
}

class PDFScreenState extends State<PDFScreen> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? mTotalPage = 0;
  var pageCont = TextEditingController();

  String encryptPath = '';

  bool isDownloadFile = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() => appStore.setLoading(true));

    initialDownload().then((value) {
      var mCurrentPAgeData = getIntAsync(PAGE_NUMBER + widget.mBookId!);
      if (mCurrentPAgeData.toString().isNotEmpty) {
        appStore.setPage(mCurrentPAgeData);
        appStore.setLoading(false);
        setState(() {
          isDownloadFile = true;
        });
      } else {
        appStore.setPage(1);
        appStore.setLoading(false);
      }
    });
  }

  Future initialDownload() async {
    await 2.seconds.delay;
    encryptPath = widget.mBookPath!.replaceAll('.aes', '');
    await decryptFile(encryptPath);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      resizeToAvoidBottomInset: false,
      appBar: appBar(context, title: widget.mTitle),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            isDownloadFile
                ? PDFView(
                    filePath: encryptPath,
                    pageSnap: false,
                    swipeHorizontal: false,
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    nightMode: appStore.isDarkModeOn == true ? true : false,
                    onPageChanged: (int? page, int? total) {
                      setValue(PAGE_NUMBER + widget.mBookId.toString(), page!);
                      setState(() {
                        appStore.setPage(page);
                        mTotalPage = total;
                      });
                    },
                    defaultPage: appStore.page!,
                  ).visible(!appStore.isLoading)
                : SizedBox(),
            Observer(builder: (context) {
              return appLoaderWidget.center().visible(appStore.isLoading);
            })
          ],
        );
      }),
      floatingActionButton: Container(
        decoration: boxDecorationRoundedWithShadow(50, backgroundColor: appStore.appBarColor!),
        padding: EdgeInsets.all(16),
        child: Text(keyString(context, "lbl_go_to")! + " ${appStore.page} / $mTotalPage", style: boldTextStyle()),
      ).onTap(() async {
        int? v = await showInDialog(
          context,
          backgroundColor: appStore.appBarColor,
          actions: [
            Text(keyString(context, "lbl_ok")!, style: boldTextStyle(color: Theme.of(context).primaryColor)).paddingAll(8).onTap(() async {
              Navigator.pop(context, pageCont.text.toInt());
              setState(() {});
            }),
            Text(keyString(context, "lbl_cancel")!, style: secondaryTextStyle(size: 16)).paddingAll(8).onTap(() {
              Navigator.pop(context);
            })
          ],
          child: EditText(hintText: keyString(context, "lbl_enter_page_number"), isPassword: false, mController: pageCont, mKeyboardType: TextInputType.number),
          contentPadding: EdgeInsets.all(16),
          shape: dialogShape(),
          title: Text(keyString(context, "lbl_enter_page_number")!),
        );

        if (v != null) {
          PDFViewController pdf = await _controller.future;
          appStore.setPage(v);
          await pdf.setPage(v);
          setState(() {});
        }
      }),
    );
  }
}
