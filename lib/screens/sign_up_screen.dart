import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/RegisterResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/dashboard_screen.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'NoInternetConnection.dart';
import 'error_view_screeen.dart';

class SignUpScreen extends StatefulWidget {
  final String? userName;

  const SignUpScreen({Key? key, this.userName}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode firstNameControllerFocusNode = FocusNode();
  FocusNode lastNameControllerFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  var autoValidate = false;
  String mUsername = '';

  ///register api call
  Future<void> registerUser(request) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        appStore.setLoading(true);
        await getRegisterUserRestApi(request).then((res) {
          appStore.setLoading(false);
          RegisterResponse response = RegisterResponse.fromJson(res);
          if (response.code == 200) {
            if (widget.userName != null) {
              if (widget.userName!.isNotEmpty) {
                var request = {"username": widget.userName, "password": widget.userName};
                log("Request" + request.toString());
                signInApi(request);
              } else {
                toast(keyString(context, "lbl_registration_completed"));
                finish(context);
              }
            } else {
              toast(keyString(context, "lbl_registration_completed"));
              finish(context);
            }
            setState(() {});
          } else if (response.code == 406) {
            ErrorViewScreen(message: response.message.toString()).launch(context);
          } else {
            ErrorViewScreen(message: "400 Error").launch(context);
          }
        }).catchError((onError) {
          appStore.setLoading(false);

          log("Error" + onError.toString());
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  ///login api call
  Future<void> signInApi(req) async {
    appStore.setLoading(true);
    await getLoginUserRestApi(req).then((res) async {
      if (!mounted) return;
      await appStore.setUserName(res['user_nicename']);
      await appStore.setToken(res['token']);
      await appStore.setFirstName(res['first_name']);
      await appStore.setLastName(res['last_name']);
      await appStore.setDisplayName(res['user_display_name']);
      await appStore.setUserId(res['user_id']);
      await appStore.setUserEmail(res['user_email']);
      await appStore.setAvatar(res['avatar']);

      if (res['book_profile_image'] != null) {
        appStore.setProfileImage(res['book_profile_image']);
      }
      await appStore.setLoggedIn(true);
      await appStore.setSocialLogin(true);

      appStore.setLoading(false);
      DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
    }).catchError((error) {
      log("Error" + error.toString());
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void initState() {
    if (widget.userName.isEmptyOrNull) {
      mUsername = "";
    } else {
      mUsername = widget.userName.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);
    return Observer(builder: (context) {
      return Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        body: Stack(
          children: <Widget>[
            Container(
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [Color(0xE64268cd), Color(0xBF4268cd), Color(0xA64268cd)]),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  30.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius)),
                        child: Image.asset("main_logo.png", width: 60, height: 60),
                      ),
                      8.height,
                      Text(keyString(context, 'lbl_sign_up')!, style: boldTextStyle(size: 40, color: Colors.white)),
                      Text(keyString(context, 'lbl_welcome_back')!, style: secondaryTextStyle(color: Colors.white, size: 16)),
                    ],
                  ).paddingAll(16),
                  16.height,
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: appStore.isDarkModeOn ? appStore.appColorPrimaryLightColor! : Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          60.height,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(boxShadow: defaultBoxShadow()),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                      color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
                                    ),
                                    child: AppTextField(
                                      controller: firstNameController,
                                      autoFocus: false,
                                      focus: firstNameControllerFocusNode,
                                      nextFocus: lastNameControllerFocusNode,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: InputDecoration(
                                        hintText: "First  Name",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                      color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
                                    ),
                                    child: AppTextField(
                                      controller: lastNameController,
                                      autoFocus: false,
                                      focus: lastNameControllerFocusNode,
                                      nextFocus: emailFocusNode,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: InputDecoration(
                                        hintText: 'Last Name',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                      color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
                                    ),
                                    child: AppTextField(
                                      controller: emailController,
                                      autoFocus: false,
                                      focus: emailFocusNode,
                                      nextFocus: passwordFocusNode,
                                      textFieldType: TextFieldType.EMAIL,
                                      decoration: InputDecoration(
                                        hintText: keyString(context, "hint_enter_email"),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                      color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
                                    ),
                                    child: AppTextField(
                                      controller: passwordController,
                                      textFieldType: TextFieldType.PASSWORD,
                                      autoFocus: false,
                                      focus: passwordFocusNode,
                                      nextFocus: confirmPasswordFocusNode,
                                      decoration: InputDecoration(
                                        hintText: keyString(context, "hint_enter_password"),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                      color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
                                    ),
                                    child: AppTextField(
                                      controller: confirmPasswordController,
                                      textFieldType: TextFieldType.PASSWORD,
                                      autoFocus: false,
                                      focus: confirmPasswordFocusNode,
                                      decoration: InputDecoration(
                                        hintText: keyString(context, "hint_re_enter_password"),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 24),
                          46.height,
                          AppButton(
                            text: keyString(context, "lbl_sign_up"),
                            textStyle: boldTextStyle(color: Colors.white),
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
                            width: context.width() * 0.7,
                            color: PRIMARY_COLOR,
                            onTap: () {
                              hideKeyboard(context);
                              var request = {
                                "first_name": "${firstNameController.text}",
                                "last_name": "${lastNameController.text}",
                                "email": "${emailController.text}",
                                "username": widget.userName != null
                                    ? widget.userName!.isNotEmpty
                                        ? widget.userName
                                        : emailController.text
                                    : emailController.text,
                                "password": widget.userName != null
                                    ? widget.userName!.isNotEmpty
                                        ? widget.userName
                                        : passwordController.text
                                    : passwordController.text,
                              };
                              if (!mounted) return;
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  appStore.setLoading(true);
                                  registerUser(request);
                                } else {
                                  appStore.setLoading(false);
                                  setState(() {
                                    autoValidate = true;
                                  });
                                }
                              });
                            },
                          ),
                          8.height,
                          Text(keyString(context, "lbl_already_have_an_account")!, style: primaryTextStyle()).onTap(() {
                            finish(context);
                          }),
                        ],
                      ),
                    ),
                  ).expand()
                ],
              ),
            ),
            appStore.isLoading ? Container(child: CircularProgressIndicator(), alignment: Alignment.center) : SizedBox(),
          ],
        ),
      );
    });
  }
}
