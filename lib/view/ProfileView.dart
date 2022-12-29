import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/screens/about_us_screen.dart';
import 'package:flutterapp/screens/author_list_screen.dart';
import 'package:flutterapp/screens/category_list_screen.dart';
import 'package:flutterapp/screens/change_password_screen.dart';
import 'package:flutterapp/screens/default_setting_screen.dart';
import 'package:flutterapp/screens/edit_profile_screen.dart';
import 'package:flutterapp/screens/my_bookmark_screen.dart';
import 'package:flutterapp/screens/my_cart_screen.dart';
import 'package:flutterapp/screens/sign_in_screen.dart';
import 'package:flutterapp/screens/transaction_history_screen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  String userImage = "";

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    if (appStore.profileImage.isNotEmpty) {
      userImage = appStore.profileImage;
    } else {
      userImage = appStore.avatar;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.scaffoldBackground!);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: ''),
        backgroundColor: appStore.scaffoldBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(keyString(context, 'title_account')!, style: boldTextStyle(size: 14)).paddingOnly(right: 16, left: 16),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                leading: CircleAvatar(backgroundImage: NetworkImage(userImage), radius: context.width() * 0.07),
                title: appStore.firstName.validate() + ' ' + appStore.lastName.validate(),
                titleTextStyle: boldTextStyle(size: 22),
                subTitle: appStore.userEmail.validate(),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide).whenComplete(getUserDetails);
                },
              ).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_sign_in')!,
                titleTextStyle: primaryTextStyle(size: 20),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ).visible(!appStore.isLoggedIn),
              Divider(color: Colors.grey),
              Text(keyString(context, 'lbl_content')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8),
              Row(
                children: [
                  Text(keyString(context, 'lbl_mode')!, style: primaryTextStyle(size: 18)).expand(),
                  Switch(
                    value: appStore.isDarkModeOn,
                    activeColor: PRIMARY_COLOR,
                    activeTrackColor: PRIMARY_COLOR,
                    onChanged: (val) async {
                      appStore.toggleDarkMode(value: val);
                      await setValue(isDarkModeOnPref, val);
                    },
                  ),
                ],
              ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8).onTap(() async {
                if (getBoolAsync(isDarkModeOnPref)) {
                  appStore.toggleDarkMode(value: false);
                  await setValue(isDarkModeOnPref, false);
                } else {
                  appStore.toggleDarkMode(value: true);
                  await setValue(isDarkModeOnPref, true);
                }
              }),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_default_settings')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  DefaultSettingScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_change_pwd')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  ChangePasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ).visible(appStore.isLoggedIn && !appStore.isSocialLogin),
              Divider(color: Colors.grey),
              Text(keyString(context, 'lbl_list')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_author')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  AuthorListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_categories')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  CategoriesListScreen(isShowBack: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_transaction_history')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  TransactionHistoryScreen().launch(context);
                },
              ).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_my_bookmark')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  MyBookMarkScreen().launch(context);
                },
              ).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_my_cart')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  MyCartScreen().launch(context);
                },
              ).visible(appStore.isLoggedIn),
              Divider(color: Colors.grey),
              Text(keyString(context, 'lbl_about')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_about')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  AboutUsScreen().launch(context);
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_terms_conditions')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  commonLaunchUrl(getStringAsync(TERMS_AND_CONDITIONS));
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'llb_privacy_policy')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  commonLaunchUrl(getStringAsync(PRIVACY_POLICY));
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_logout')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  logout(context);
                },
              ).visible(appStore.isLoggedIn)
            ],
          ),
        ),
      ),
    );
  }
}
