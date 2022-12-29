import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/screens/dashboard_screen.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_widget.dart';
import 'constant.dart';

Future clearSearchHistory() async {
  await setValue(SEARCH_TEXT, "");
}

Future<bool> checkPermission(widget) async {
  if (Platform.isAndroid) {
    PermissionStatus permission = await Permission.storage.request();

    if (permission == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<String> getBookFilePath(String? bookId, String url, {isSampleFile = false}) async {
  String path = await localPath;
  String filePath = path + "/" + await getBookFileName(bookId, url, isSample: isSampleFile);
  filePath = filePath.replaceAll("null/", "");
  log("Full File Path: " + filePath);
  return filePath;
}

Future<String> getBookFileName(String? bookId, String url, {isSample = false}) async {
  var name = url.split("/");
  String fileNameNew = url;
  if (name.length > 0) {
    fileNameNew = name[name.length - 1];
  }
  fileNameNew = fileNameNew.replaceAll("%", "");
  var fileName = isSample ? bookId! + "_sample_" + fileNameNew : bookId! + "_purchased_" + fileNameNew;
  log("File Name: " + fileName);
  //log("File Name: " + userId.toString() + "_" + fileName);
  // return userId.toString() + "_" + fileName;
  return fileName;
}

Future<String> get localPath async {
  Directory? directory;
  if (Platform.isAndroid) {
    directory = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    throw "Unsupported platform";
  }
  // log("localPath: " + directory.absolute.path + "/" + userId.toString() + "");
  //return directory.absolute.path + "/" + userId.toString() + "";
  log("localPath: " + directory!.path);
  return directory.path;
}

Future addToSearchArray(searchText) async {
  String oldValue = getStringAsync(SEARCH_TEXT);
  if (!oldValue.contains(searchText)) {
    setValue(SEARCH_TEXT, oldValue + searchText + ",");
  }
}

Future<List<String>> getSearchValue() async {
  var searchString = getStringAsync(SEARCH_TEXT);
  searchString = searchString.trim();
  List<String> data = searchString.trim().split(',');
  data.removeAt(data.length - 1);
  return data;
}

Future logout(BuildContext context) async {
  ConfirmAction? res = await showConfirmDialogs(context, keyString(context, "lbl_are_your_logout"), keyString(context, "lbl_yes"), keyString(context, "lbl_cancel"));
  if (res == ConfirmAction.ACCEPT) {
    await appStore.setUserName('');
    await appStore.setToken('');
    await appStore.setFirstName('');
    await appStore.setLastName('');
    await appStore.setDisplayName('');
    await appStore.setUserId(0);
    await appStore.setUserEmail('');
    await appStore.setAvatar('');
    await appStore.setLoggedIn(false);
    await appStore.setProfileImage('');
    await appStore.setSocialLogin(false);
    myCartList.clear();
    appStore.cartCount = [];
    DashboardScreen().launch(context, isNewTask: true);
  }
}

Future<ConfirmAction?> showConfirmDialogs(context, msg, positiveText, negativeText) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: appStore.appBarColor,
        title: Text(msg, style: primaryTextStyle()),
        actions: <Widget>[
          TextButton(
            child: Text(
              negativeText,
              style: primaryTextStyle(color: appStore.appTextPrimaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          TextButton(
            child: Text(positiveText, style: primaryTextStyle(color: appStore.appTextPrimaryColor)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

Future<String> getTime() async {
  DateTime currentTime = DateTime.now().toUtc();
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  log(f.format(currentTime).toString());
  return f.format(currentTime).toString();
}

Future<String> getKey(time) async {
  String finalString = time + SALT;
  log("Final String: " + finalString);
  String md5String = md5.convert(utf8.encode(finalString)).toString();
  log("MD5 String: " + md5String);
  return md5String;
}

String? getFileNewName(downloads) {
  String? newFilename = downloads.file.substring(downloads.file.lastIndexOf("/") + 1);
  newFilename = downloads.id + "_" + newFilename;
  return newFilename;
}

Future<bool> isFileExist(downloads) async {
  String? bookName = getFileNewName(downloads);
  String path;
  bool isFileExist = false;

  path = (await _localFile(bookName)).path;
  if (!File(path).existsSync()) {
    isFileExist = false;
  } else {
    isFileExist = true;
  }

  return isFileExist;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(bookName) async {
  final path = await _localPath;
  return File('$path/$bookName');
}

Future<File> getFilePathFile(bookName) async {
  return _localFile(bookName);
}

appConfiguration(BuildContext context) {
  var width = context.width();
  var height = context.height();
  var diagonal = sqrt((width * width) + (height * height));
  var isTab = diagonal > 1100.0;
  if (isTab) {
    bookViewHeight = tab_BookViewHeight;
    bookHeight = tab_bookHeight;
    bookWidth = tab_bookWidth;
    appLoaderWH = tab_appLoaderWH;
    backIconSize = tab_backIconSize;
    bookHeightDetails = tab_bookHeightDetails;
    bookWidthDetails = tab_bookWidthDetails;
    fontSizeMedium = tab_font_size_medium;
    fontSizeXxxlarge = tab_font_size_xxxlarge;
    fontSizeMicro = tab_font_size_micro;
    fontSize25 = tab_font_size_25;
  } else {
    log("Device is Mobile");
    bookWidth = mobile_bookWidth;
    bookViewHeight = mobile_BookViewHeight;
    bookHeight = mobile_bookHeight;
    backIconSize = mobile_backIconSize;
    appLoaderWH = mobile_appLoaderWH;
    bookHeightDetails = mobile_bookHeightDetails;
    bookWidthDetails = mobile_bookWidthDetails;
    fontSizeMedium = mobile_font_size_medium;
    fontSizeXxxlarge = mobile_font_size_xxxlarge;
    fontSizeMicro = mobile_font_size_micro;
    fontSize25 = mobile_font_size_25;
  }
}

Color getOrderStatusColor(String? orderStatus) {
  if (orderStatus == PAYMENT_COMPLETED) {
    return Colors.green;
  } else if (orderStatus == PAYMENT_CANCELLED) {
    return Colors.red;
  } else {
    return Colors.black;
  }
}

Future<Color> getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor!.color;
}

List<Color> bookBackgroundColor = <Color>[
  Color(0xFFD1DAF2),
  Color(0xFFf2d1da),
  Color(0xFFdaf2d1),
  Color(0xFFF2E9D1),
  Color(0xFF80ffff),
  Color(0xFFffcc99),
  Color(0xFFffff99),
  Color(0xFFb3ffb3),
  Color(0xFFd9b3ff),
  Color(0xFFbfff80),
  Color(0xFFd1e0e0),
];
List<Color> authorBorderColor = <Color>[
  Color(0xFF2B60DE),
  Color(0xFFA52A2A),
  Color(0xFF808000),
  Color(0xFF56A5EC),
  Color(0xFF659EC7),
  Color(0xFFE9AB17),
  Color(0xFF9F000F),
  Color(0xFF872657),
  Color(0xFFF778A1),
  Color(0xFFE9E4D4),
  Color(0xFF3D3C3A),
];

bool isSingleSampleFile(int? count, var mSampleFile) {
  if (count == 0) {
    return false;
  } else if (count == 1 && mSampleFile.length > 0) {
    return false;
  }
  return true;
}

Future<String> encryptFile(filePath) async {
  String encFilepath = '';

  AesCrypt crypt = AesCrypt();
  crypt.aesSetMode(AesMode.cbc);
  crypt.setPassword(encryptionPassword);
  crypt.setOverwriteMode(AesCryptOwMode.on);

  try {
    encFilepath = crypt.encryptFileSync(filePath);
  } on AesCryptException catch (e) {
    if (e.type == AesCryptExceptionType.destFileExists) {
      print(e.message);
    }
  }
  return encFilepath;
}

Future<String> decryptFile(String filePath) async {
  String encryptedFileName = '';

  if (filePath.contains('.pdf')) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(".pdf", "");
  } else if (filePath.contains('.mp4')) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(".mp4", "");
  } else if (filePath.contains('.mp3')) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(".mp3", "");
  } else if (filePath.contains('.mov')) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(".mov", "");
  } else if (filePath.contains('.webm')) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(".webm", "");
  } else {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(".epub", "");
  }

  Directory? dir = await getExternalStorageDirectory();

  if (filePath.contains('.pdf')) {
    filePath = '${dir!.path}/$encryptedFileName.pdf.aes';
  } else if (filePath.contains('.mp4')) {
    filePath = '${dir!.path}/$encryptedFileName.mp4.aes';
  } else if (filePath.contains('.mp3')) {
    filePath = '${dir!.path}/$encryptedFileName.mp3.aes';
  } else if (filePath.contains('.mov')) {
    filePath = '${dir!.path}/$encryptedFileName.mov.aes';
  } else if (filePath.contains('.webm')) {
    filePath = '${dir!.path}/$encryptedFileName.webm.aes';
  } else {
    filePath = '${dir!.path}/$encryptedFileName.epub.aes';
  }

  String decryptFilePath = '';

  AesCrypt crypt = AesCrypt();
  crypt.aesSetMode(AesMode.cbc);
  crypt.setOverwriteMode(AesCryptOwMode.on);
  crypt.setPassword(encryptionPassword);

  try {
    decryptFilePath = crypt.decryptFileSync(filePath);

    print("$filePath");
    print('The decryption has been completed successfully.');
  } catch (e) {
    print("Error: ${e.toString()}");
  }

  return decryptFilePath;
}

/*
Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}
*/

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}
