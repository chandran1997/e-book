import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/downloaded_book.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/database_helper.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class ViewEPubFileNew extends StatefulWidget {
  DownloadModel downloads;
  static String tag = '/EpubFiles';
  String? mBookId, mBookName, mBookImage;
  bool isPDFFile = false;
  bool _isFileExist = false;

  ViewEPubFileNew(this.mBookId, this.mBookName, this.mBookImage, this.downloads, this.isPDFFile, this._isFileExist);

  @override
  ViewEPubFileNewState createState() => ViewEPubFileNewState();
}

class ViewEPubFileNewState extends State<ViewEPubFileNew> {
  EpubController? _epubReaderController;

  final storageIO = InternetFileStorageIO();

  final dbHelper = DatabaseHelper.instance;
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  TextEditingController pageCont = TextEditingController();

  bool isDownloadFile = false;
  bool isDownloadFailFile = false;

  String percentageCompleted = "";
  String fullFilePath = "";

  int? mTotalPage = 0;

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
      } else {
        appStore.setPage(0);
      }
    });
  }

  // ignore: missing_return
  Future initialDownload() async {
    if (widget._isFileExist) {
      await 1.seconds.delay;

      String filePath = await getBookFilePath(widget.mBookId, widget.downloads.file!);

      ///decryption file
      log('decrypting');

      await decryptFile(filePath);

      log('opening file');

      await _openDownloadedFile(filePath).then((value) async {
        if (filePath.contains('.epub')) {
          await 2.seconds.delay;
          await encryptFile(fullFilePath);
          await dbHelper.delete(fullFilePath);
          await File(fullFilePath).delete();
        }
      }).catchError(onError);

      appStore.setLoading(false);
      log('file opened');

      setState(() {
        isDownloadFile = true;
      });
    } else {
      requestPermission();
    }
  }

  Future<void> downloadFile() async {
    await InternetFile.get(
      widget.downloads.file.validate(),
      storage: storageIO,
      storageAdditional: storageIO.additional(
        filename: await getBookFileName(widget.mBookId, widget.downloads.file.validate()),
        location: await localPath,
      ),
      force: true,
      progress: (receivedLength, contentLength) async {
        final percentage = (receivedLength / contentLength * 100).round().toString();
        percentageCompleted = percentage + "% Completed";
        print('download progress: $receivedLength of $contentLength ($percentage%)');

        setState(() {});
      },
    ).catchError((e) {
      log('error: ${e.toString()}');
      isDownloadFailFile = true;
      setState(() {});
    });

    if (!isDownloadFailFile) {
      String filePath = await getBookFilePath(widget.mBookId, widget.downloads.file.validate());

      ///encryption file
      await encryptFile(filePath).then((value) async {
        await insertIntoDb(value);
        LiveStream().emit(REFRESH_LIBRARY_DATA);
      });
      appStore.setLoading(true);

      await _openDownloadedFile(filePath).then((value) async {
        if (filePath.contains('.epub')) {
          await 2.seconds.delay;
          await encryptFile(fullFilePath);
          await dbHelper.delete(fullFilePath);
          await File(fullFilePath).delete();
        }
        appStore.setLoading(false);
      });

      setState(() {
        isDownloadFile = true;
      });
    }
  }

  Future<void> requestPermission() async {
    if (await checkPermission(widget)) {
      downloadFile();
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).pop();
      } else {
        downloadFile();
      }
    }
  }

  // ignore: missing_return
  Future _openDownloadedFile(String filePath) async {
    setState(() {
      fullFilePath = filePath;
    });

    if (!widget.isPDFFile) {
      _epubReaderController = EpubController(document: EpubDocument.openFile(File(filePath)));
    }
  }

  Future<void> insertIntoDb(filePath) async {
    /**
     * Store data to db for offline usage
     */
    DownloadedBook _download = DownloadedBook();
    _download.bookId = widget.mBookId;
    _download.bookName = widget.mBookName;
    _download.frontCover = widget.mBookImage;
    _download.fileType = widget.isPDFFile ? "PDF File" : "EPub File";
    _download.filePath = filePath;
    _download.userId = appStore.userId.toString();
    _download.fileName = widget.downloads.name;
    await dbHelper.insert(_download);
  }

  Future<bool> backPress() async {
    appStore.setLoading(true);

    try {
      log('encrypting');

      ///delete original file
      log('deleting original file');
      await dbHelper.delete(fullFilePath);
      await File(fullFilePath).delete();

      appStore.setLoading(false);
      return Future.value(true);
    } catch (e) {
      log(e);

      appStore.setLoading(false);
      return Future.value(false);
    }
  }

  void _showCurrentEpubCfi(context) {
    final cfi = _epubReaderController?.generateEpubCfi();

    if (cfi != null) {
      _epubReaderController?.gotoEpubCfi(cfi);
    }
  }

  @override
  void dispose() {
    _epubReaderController!.dispose();
    appStore.isDarkModeOn ? setStatusBarColor(appStore.isLoading ? appStore.scaffoldBackground! : appStore.scaffoldBackground!) : setStatusBarColor(appStore.isLoading ? appStore.scaffoldBackground! : Colors.grey.shade300);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.scaffoldBackground!);
    return WillPopScope(
      onWillPop: () async {
        return backPress();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appStore.scaffoldBackground,
          appBar: appBarWidget(
            widget.downloads.name.toString(),
            backWidget: Icon(Icons.arrow_back, color: appStore.iconColor).onTap(() async {
              await backPress();

              finish(context);
            }),
          ),
          body: Observer(
            builder: (_) {
              return Stack(
                children: [
                  Builder(
                    builder: (context) => !isDownloadFile
                        ? isDownloadFailFile
                            ? new Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: spacing_standard_new),
                                      child: Text(
                                        keyString(context, "lbl_download_failed")!,
                                        style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              )
                            : new Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    appDownloadWidget,
                                    Padding(
                                      padding: const EdgeInsets.only(top: spacing_standard_new),
                                      child: Text(percentageCompleted, style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor)),
                                    )
                                  ],
                                ),
                              )
                        : !widget.isPDFFile
                            ? _epubReaderController != null
                                ? EpubView(
                                    builders: EpubViewBuilders<DefaultBuilderOptions>(
                                      options: const DefaultBuilderOptions(),
                                      chapterDividerBuilder: (_) => const Divider(),
                                    ),
                                    controller: _epubReaderController!,
                                  )
                                : SizedBox()
                            : Observer(
                                builder: (_) => Container(
                                  height: context.height(),
                                  child: PDFView(
                                    filePath: fullFilePath,
                                    pageSnap: false,
                                    swipeHorizontal: false,
                                    onViewCreated: (PDFViewController pdfViewController) {
                                      _controller.complete(pdfViewController);
                                    },
                                    nightMode: appStore.isDarkModeOn == true ? true : false,
                                    onPageChanged: (int? page, int? total) {
                                      setValue(PAGE_NUMBER + widget.mBookId.toString(), page);
                                      setState(() {
                                        appStore.setPage(page.validate() + 1);
                                        mTotalPage = total;
                                      });
                                    },
                                    defaultPage: appStore.page!,
                                  ),
                                ),
                              ),
                  ),
                  if (appStore.isLoading && widget._isFileExist) Loader()
                ],
              );
            },
          ),
          floatingActionButton: Container(
            decoration: boxDecorationRoundedWithShadow(50, backgroundColor: appStore.appBarColor!),
            padding: EdgeInsets.all(16),
            child: Text(keyString(context, "lbl_go_to")! + "${widget.isPDFFile ? " ${appStore.page.validate()} / $mTotalPage" : ''}", style: boldTextStyle()),
          ).onTap(() async {
            if (!widget.isPDFFile) {
              _showCurrentEpubCfi(context);
            } else {
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
            }
          }),
        ),
      ),
    );
  }
}
