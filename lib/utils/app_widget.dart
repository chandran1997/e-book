import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/screens/PDFScreen.dart';
import 'package:flutterapp/screens/dashboard_screen.dart';
import 'package:flutterapp/screens/epub_screen.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:intl/intl.dart' as init;
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import 'images.dart';

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color? bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      boxShadow: showShadow ? [BoxShadow(color: appStore.isDarkModeOn ? appStore.scaffoldBackground! : shadow_color, blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  var isPassword;
  var hintText;
  var isSecure;
  int fontSize;
  var textColor;
  var fontFamily;
  var text;
  var visible;
  var validator;
  var maxLine;
  TextEditingController? mController;
  VoidCallback? onPressed;
  Function? onFieldSubmitted;
  TextInputType? mKeyboardType;

  EditText({
    var this.fontSize = 20,
    var this.textColor = textPrimaryColor,
    var this.hintText = '',
    var this.isPassword = true,
    var this.isSecure = false,
    var this.text = "",
    var this.mController,
    this.validator,
    this.onFieldSubmitted,
    this.mKeyboardType,
    var this.maxLine = 1,
    var this.visible = false,
  });

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isSecure) {
      return TextFormField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: PRIMARY_COLOR,
        maxLines: widget.maxLine,
        readOnly: widget.visible,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted as void Function(String)?,
        keyboardType: widget.mKeyboardType,
        style: TextStyle(fontSize: widget.fontSize.toDouble(), color: appStore.appTextPrimaryColor, fontFamily: widget.fontFamily),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(26, 16, 4, 16),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: appStore.textSecondaryColor),
          fillColor: appStore.editTextBackColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
          ),
          errorMaxLines: 2,
          errorStyle: primaryTextStyle(color: Colors.red, size: 12),
        ),
      );
    } else {
      return TextFormField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: PRIMARY_COLOR,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted as void Function(String)?,
        style: TextStyle(fontSize: widget.fontSize.toDouble(), color: appStore.appTextPrimaryColor, fontFamily: widget.fontFamily),
        decoration: InputDecoration(
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                widget.isPassword = !widget.isPassword;
              });
            },
            child: new Icon(
              widget.isPassword ? Icons.visibility : Icons.visibility_off,
              color: appStore.iconColor,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: appStore.textSecondaryColor),
          filled: true,
          fillColor: appStore.editTextBackColor,
          errorMaxLines: 2,
          errorStyle: primaryTextStyle(color: Colors.red, size: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
          ),
        ),
      );
    }
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

// Book Loader View
Widget bookLoaderWidget = Container(
  width: 100,
  height: 100,
  child: Lottie.asset(BOOK_LOADER),
);

Widget viewMoreDataLoader = Container(
  width: 200,
  height: 20,
  child: Lottie.asset(MORE_DATA_LOADER),
);

Widget appDownloadWidget = Container(
  width: 120,
  height: 120,
  color: Colors.transparent,
  // child: Lottie.asset(FILE_DOWNLOAD_LOADER),
  child: Lottie.asset('assets/download.json'),
);

Widget appLoaderWidget = Container(
  width: appLoaderWH,
  height: appLoaderWH,
  //child: Lottie.asset(APP_LOADER),
  child: Lottie.asset('assets/app_loadernew.json'),
);

bool getDeviceTypePhone() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? true : false;
}

double getChildAspectRatio() {
  if (getDeviceTypePhone()) {
    return 210 / 220;
  } else {
    return 190 / 220;
  }
}

int getCrossAxisCount() {
  if (getDeviceTypePhone()) {
    return 2;
  } else {
    return 4;
  }
}

// ignore: must_be_immutable
class AppBtn extends StatefulWidget {
  var value;
  VoidCallback onPressed;

  AppBtn({required this.value, required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return AppBtnState();
  }
}

class AppBtnState extends State<AppBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: widget.onPressed,
      child: Padding(
        padding: EdgeInsets.fromLTRB(spacing_standard_new.toDouble(), 16, spacing_standard_new.toDouble(), 16),
        child: Center(
            child: Text(
          widget.value,
          style: boldTextStyle(
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}

Widget getLoadingProgress(loadingProgress) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
      ),
    ),
  );
}

PreferredSizeWidget appBar(BuildContext context, {List<Widget>? actions, bool showBack = true, bool showTitle = true, bool isPopOperation = false, String? title, double? titleSpacing, double? fontSize}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: appStore.appBarColor,
    elevation: 0,
    leading: showBack
        ? Icon(Icons.arrow_back, color: appStore.iconColor).onTap(() {
            finish(context);
          })
        : null,
    titleSpacing: titleSpacing ?? 0,
    title: showTitle
        ? Html(
            data: title,
            style: {
              'body': Style(fontWeight: FontWeight.bold, fontSize: FontSize(fontSize ?? 16), color: textPrimaryColorGlobal),
            },
          )
        : null,
    actions: actions,
  );
}

// ignore: must_be_immutable
class CustomTheme extends StatelessWidget {
  Widget? child;

  CustomTheme({this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn
          ? ThemeData.dark().copyWith(
              backgroundColor: appStore.scaffoldBackground,
            )
          : ThemeData.light(),
      child: child!,
    );
  }
}

String reviewConvertDate(date) {
  try {
    return date != null ? init.DateFormat(reviewDateFormat).format(DateTime.parse(date)) : '';
  } catch (e) {
    log(e.toString());
    return '';
  }
}

readFile(context, String? mBookId, String filePath, String? name, {isCloseApp = true}) async {
  if (filePath.contains(".pdf")) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(mBookId, filePath, name)));
  } else if (filePath.contains(".epub")) {
    EpubScreen(mBookId: mBookId, mBookPath: filePath, mTitle: name).launch(context);
    if (isCloseApp) Navigator.of(context).pop();
  }
}

Widget titleSilverAppBarWidget(BuildContext? context, {String? title1, String? title2, bool? isHome}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.green, width: 3.0))),
        child: Text(
          title1!,
          style: isHome! ? primaryTextStyle(color: appStore.appTextPrimaryColor, size: 28) : boldTextStyle(color: appStore.appTextPrimaryColor, size: 28),
        ),
      ),
      4.width,
      Text(title2!, style: isHome ? primaryTextStyle(color: appStore.appTextPrimaryColor, size: 28) : boldTextStyle(size: 28)),
    ],
  ).paddingLeft(16);
}

BottomNavigationBarItem bottomNavigationBarItem(String iconData, String tabName) {
  return BottomNavigationBarItem(
      backgroundColor: PRIMARY_COLOR.withOpacity(0.4),
      icon: Image.asset(
        iconData,
        color: appStore.iconColor,
        height: 25,
        width: 25,
      ),
      activeIcon: Image.asset(iconData, height: 26, width: 26, color: PRIMARY_COLOR),
      label: tabName);
}

InputDecoration inputDecoration(String? title, {Color? borderColor, Icon? prefixIcon}) {
  return InputDecoration(
    hintText: title.validate(),
    hintStyle: secondaryTextStyle(color: Colors.grey),
    filled: true,
    fillColor: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
    prefixIcon: prefixIcon != null ? Icon(Icons.search, color: appStore.iconColor) : SizedBox(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? PRIMARY_COLOR), borderRadius: radius(defaultRadius)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? PRIMARY_COLOR), borderRadius: radius(defaultRadius)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: radius(defaultRadius)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: radius(defaultRadius)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: radius(defaultRadius)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: PRIMARY_COLOR), borderRadius: radius(defaultRadius)),
  );
}

Widget freeBookNotAvailableWidget(BuildContext context) {
  return Container(
    width: context.width(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        32.height,
        Image.asset("logo.png", width: 150),
        32.height,
        Text(keyString(context, 'lbl_book_not_available')!, style: boldTextStyle(size: 18, color: appStore.appTextPrimaryColor)),
        8.height,
      ],
    ),
  );
}

Widget bookNotAvailableWidget(BuildContext context, {String? title, String? buttonTitle}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(margin: EdgeInsets.all(spacing_standard_30), child: Image.asset("logo.png", width: 150)),
      16.height,
      Text(title!, style: boldTextStyle(size: 18, color: appStore.appTextPrimaryColor), textAlign: TextAlign.center),
      8.height,
      AppButton(
          color: PRIMARY_COLOR,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          text: buttonTitle,
          textColor: Colors.white,
          onTap: () {
            DashboardScreen().launch(context);
          })
    ],
  );
}

Widget searchWidget(BuildContext context, {TextEditingController? controller, Function(String)? onChanged, Function(dynamic)? onFieldSubmitted, String? hint, bool? isSearch = false, Function? textToSpeech}) {
  return Container(
    child: AppTextField(
        cursorColor: context.iconColor,
        textStyle: primaryTextStyle(),
        textFieldType: TextFieldType.OTHER,
        autoFocus: false,
        decoration: inputDecoration(
          hint,
          borderColor: PRIMARY_COLOR,
          prefixIcon: Icon(Icons.search, color: appStore.iconColor),
        ),
        suffix: isSearch!
            ? Icon(
                Icons.mic,
                color: appStore.iconColor,
              ).onTap(textToSpeech)
            : SizedBox(height: 0, width: 0),
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        maxLines: 1,
        onChanged: onChanged),
  );
}

Widget noDataFoundWidget(BuildContext context, {String? title}) {
  return Container(
    width: context.width(),
    height: context.height(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(spacing_standard_30),
          child: Image.asset(ic_book_logo, width: 150),
        ),
        Text(
          title!,
          style: boldTextStyle(size: 20),
        ),
      ],
    ),
  );
}

Widget noDataFound({String? title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/no_data_found.png', width: 200, height: 200, fit: BoxFit.cover),
      Text(title!, style: primaryTextStyle(), textAlign: TextAlign.center),
    ],
  );
}

Widget priceWidget({String? price, String? currency, int? size}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(currency!, style: boldTextStyle(color: PRIMARY_COLOR, size: size ?? 16)),
      Text(price!, style: boldTextStyle(color: PRIMARY_COLOR, size: size ?? 16)),
    ],
  );
}

Widget salePriceWidget({String? salePrice, String? regularPrice, int? size}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(salePrice!, style: boldTextStyle()),
      16.width.visible(salePrice.isNotEmpty),
      Row(
        children: [
          Text('${getStringAsync(CURRENCY_SYMBOL)}', style: boldTextStyle(color: PRIMARY_COLOR, size: size ?? 16)).visible(regularPrice!.isNotEmpty),
          Text(
            '$regularPrice',
            style: boldTextStyle(color: salePrice.isNotEmpty ? Colors.grey : PRIMARY_COLOR, decoration: salePrice.isNotEmpty ? TextDecoration.lineThrough : TextDecoration.none, size: size ?? 16),
          ),
        ],
      )
    ],
  );
}
