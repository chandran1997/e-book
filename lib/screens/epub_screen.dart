import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class EpubScreen extends StatefulWidget {
  final String? mBookId, mBookPath, mTitle;

  const EpubScreen({this.mBookId, this.mBookPath, this.mTitle});

  @override
  State<EpubScreen> createState() => _EpubScreenState();
}

class _EpubScreenState extends State<EpubScreen> {
  EpubController? _epubReaderController;
  bool isDownloadFile = false;
  String encryptPath = '';

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

    log('encryptPath : $encryptPath');

    _epubReaderController = EpubController(document: EpubDocument.openFile(File(encryptPath)));
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
                ? _epubReaderController != null
                    ? EpubView(
                        builders: EpubViewBuilders<DefaultBuilderOptions>(
                          options: const DefaultBuilderOptions(),
                          chapterDividerBuilder: (_) => const Divider(),
                        ),
                        controller: _epubReaderController!,
                      ).visible(!appStore.isLoading)
                    : SizedBox()
                : SizedBox(),
            appLoaderWidget.center().visible(appStore.isLoading),
          ],
        );
      }),
      floatingActionButton: Container(
        decoration: boxDecorationRoundedWithShadow(50, backgroundColor: appStore.appBarColor!),
        padding: EdgeInsets.all(16),
        child: Text(keyString(context, "lbl_go_to")!, style: boldTextStyle()),
      ).onTap(() async {
        final cfi = _epubReaderController?.generateEpubCfi();

        if (cfi != null) {
          _epubReaderController?.gotoEpubCfi(cfi);
        }
      }),
    );
  }
}
