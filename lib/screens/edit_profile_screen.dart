import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/CustomerResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'error_view_screeen.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  var mFirstNameCont = TextEditingController();
  var mLastNameCont = TextEditingController();
  var mEmailCont = TextEditingController();

  File? mSelectedImage;
  bool mIsNetwork = false;
  var mCustomer = <MetaDataResponse>[];
  SharedPreferences? pref;
  var autoValidate = false;
  String? avatar = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      appStore.setLoading(true);

      await getCustomerData();
    });
  }

  Future<void> getCustomerData() async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        mIsNetwork = true;

        await getCustomer(appStore.userId).then((res) {
          appStore.setLoading(false);
          mFirstNameCont.text = res['first_name'];
          mLastNameCont.text = res['last_name'];
          mEmailCont.text = res['email'];
          Iterable newest = res['meta_data'];
          mCustomer = newest.map((model) => MetaDataResponse.fromJson(model)).toList();
          appStore.setFirstName(res['first_name']);
          appStore.setLastName(res['last_name']);

          mCustomer.forEachIndexed((element, index) {
            if (element.key == "iqonic_profile_image") {
              if (mCustomer.isNotEmpty) {
                appStore.setProfileImage(element.value);
              } else {
                appStore.setProfileImage(res['avatar_url']);
              }
            }
          });
        }).catchError((onError) {
          appStore.setLoading(false);
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        mIsNetwork = false;
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<void> saveUser() async {
    hideKeyboard(context);
    var request = {
      'first_name': mFirstNameCont.text,
      'last_name': mLastNameCont.text,
    };
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        mIsNetwork = true;
        appStore.setLoading(true);

        updateCustomer(appStore.userId, request).then((res) {
          appStore.setLoading(false);
          appStore.setFirstName(res['first_name']);
          appStore.setLastName(res['last_name']);
          toast(keyString(context, "lbl_profile_saved"));
          finish(context);
        }).catchError((onError) {
          appStore.setLoading(false);
          log(onError.toString());
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        mIsNetwork = false;
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  Future pickImage() async {
    final pickedFile = await (ImagePicker().pickImage(source: ImageSource.gallery));
    File image = File(pickedFile!.path);

    setState(() {
      mSelectedImage = image;
    });

    if (mSelectedImage != null) {
      ConfirmAction? res = await showConfirmDialogs(context, keyString(context, "lbl_confirmation_upload_image"), keyString(context, "lbl_yes"), keyString(context, "lbl_no"));

      if (res == ConfirmAction.ACCEPT) {
        var base64Image = base64Encode(mSelectedImage!.readAsBytesSync());
        var request = {'base64_img': base64Image};
        await isNetworkAvailable().then((bool) async {
          if (bool) {
            mIsNetwork = true;
            await saveProfileImage(request).then((res) async {
              appStore.setLoading(false);
              setState(() {
                getCustomerData();
              });
            }).catchError((onError) {
              appStore.setLoading(false);
            });
          } else {
            mIsNetwork = false;
            appStore.setLoading(false);
            NoInternetConnection().launch(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, "lbl_edit_profile")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: mSelectedImage == null
                                    ? appStore.profileImage.isEmpty
                                        ? Image.asset("ic_profile.png", width: 100, height: 100, fit: BoxFit.cover)
                                        : Image.network(
                                            appStore.profileImage.validate(),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return getLoadingProgress(loadingProgress);
                                            },
                                          )
                                    : Image.file(mSelectedImage!, width: 120, height: 120, fit: BoxFit.cover),
                              ),
                              Container(
                                height: 35,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: PRIMARY_COLOR, width: 1), color: whileColor),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: PRIMARY_COLOR,
                                ),
                              ).onTap(() {
                                pickImage();
                              }).visible(appStore.isSocialLogin == false)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  16.height,
                  EditText(
                    hintText: keyString(context, "hint_enter_first_name"),
                    isPassword: false,
                    mController: mFirstNameCont,
                    mKeyboardType: TextInputType.text,
                    validator: (String? s) {
                      if (s!.trim().isEmpty) return keyString(context, "lbl_first_name")! + " " + keyString(context, "lbl_field_required")!;
                      if (s.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) return keyString(context, "error_string");
                      return null;
                    },
                  ),
                  16.height,
                  EditText(
                    hintText: keyString(context, "hint_enter_last_name"),
                    isPassword: false,
                    mController: mLastNameCont,
                    mKeyboardType: TextInputType.text,
                    validator: (String? s) {
                      if (s!.trim().isEmpty) return keyString(context, "lbl_last_name")! + " " + keyString(context, "lbl_field_required")!;
                      if (s.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) return keyString(context, "error_string");
                      return null;
                    },
                  ),
                  16.height,
                  EditText(hintText: keyString(context, "hint_enter_email"), isPassword: false, mController: mEmailCont, visible: true),
                  16.height,
                  AppButton(
                    width: context.width(),
                    color: PRIMARY_COLOR,
                    text: keyString(context, "lbl_save"),
                    textStyle: boldTextStyle(color: Colors.white),
                    onTap: () {
                      hideKeyboard(context);
                      if (!mounted) return;
                      setState(() {
                        if (_formKey.currentState!.validate()) {
                          saveUser();
                        } else {
                          appStore.setLoading(false);
                          autoValidate = true;
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          ).visible(mIsNetwork = true),
          Observer(builder: (context) {
            return CircularProgressIndicator().visible(appStore.isLoading);
          })
        ],
      ),
    );
  }
}
