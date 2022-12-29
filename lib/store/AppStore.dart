import 'package:flutter/material.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isDarkModeOn = false;

  @observable
  Color? scaffoldBackground;

  @observable
  Color? backgroundColor;

  @observable
  Color? backgroundSecondaryColor;

  @observable
  Color? appTextPrimaryColor;

  @observable
  Color? editTextBackColor;

  @observable
  Color? appColorPrimaryLightColor;

  @observable
  Color? textSecondaryColor;

  @observable
  Color? appBarColor;

  @observable
  Color? iconColor;

  @observable
  Color? iconSecondaryColor;

  @observable
  String selectedLanguage = 'en';

  @observable
  var selectedDrawerItem = 0;

  @observable
  List<String> languageCode = ['ar'];

  @observable
  bool isRTL = false;

  @observable
  int? page = 0;

  @observable
  bool isLoading = false;

  @observable
  bool isAddToCart = false;

  @observable
  bool isReview = false;

  @observable
  List<MyCartResponse> cartList = [];

  @observable
  List<String> cartCount = <String>[].asObservable();

  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE_CODE;

  @computed
  bool get isNetworkConnected => connectivityResult != ConnectivityResult.none;

  @observable
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @observable
  String deviceId = '';

  @observable
  String userName = '';

  @observable
  String token = '';

  @observable
  String firstName = '';

  @observable
  String lastName = '';

  @observable
  String displayName = '';

  @observable
  String userEmail = '';

  @observable
  String profileImage = '';

  @observable
  int userId = 0;

  @observable
  String avatar = '';

  @observable
  String password = '';

  @observable
  bool isFirstTime = true;

  @observable
  bool isLoggedIn = false;

  @observable
  bool isSocialLogin = false;

  @observable
  bool isTokenExpired = false;

  @action
  Future<void> toggleDarkMode({bool? value}) async {
    isDarkModeOn = value ?? !isDarkModeOn;

    if (isDarkModeOn) {
      scaffoldBackground = appBackgroundColorDark;
      appBarColor = appBackgroundColorDark;
      backgroundColor = Colors.white;
      backgroundSecondaryColor = Colors.white;
      appColorPrimaryLightColor = cardBackgroundBlackDark;
      iconColor = iconColorPrimary;
      iconSecondaryColor = iconColorSecondary;
      appTextPrimaryColor = whiteColor;
      textSecondaryColor = Colors.white54;
      editTextBackColor = cardBackgroundBlackDark;
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = Colors.white54;
      shadowColorGlobal = appShadowColorDark;
    } else {
      scaffoldBackground = screenBackgroundColor;
      appBarColor = screenBackgroundColor;
      backgroundColor = Colors.black;
      backgroundSecondaryColor = appSecondaryBackgroundColor;
      appColorPrimaryLightColor = appColorPrimaryLight;
      iconColor = iconColorPrimaryDark;
      iconSecondaryColor = iconColorSecondaryDark;
      appTextPrimaryColor = TextPrimaryColor;
      textSecondaryColor = appTextSecondaryColor;
      editTextBackColor = whileColor;
      textPrimaryColorGlobal = TextPrimaryColor;
      textSecondaryColorGlobal = appTextSecondaryColor;
      shadowColorGlobal = shadow_color;
    }

    await setValue(isDarkModeOnPref, isDarkModeOn);
  }

  @action
  void setDrawerItemIndex(int aIndex) => selectedDrawerItem = aIndex;

  @action
  void setPage(int? aIndex) => page = aIndex;

  @action
  Future<void> checkRTL({String? value}) async {
    log("Language" + LANGUAGE);
    languageCode.forEach((element) {
      if (element.contains(value!)) {
        isRTL = true;
        log("RTL" + value.toString());
      } else {
        isRTL = false;
        log("LTR" + value.toString());
      }
    });
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void setAddToCart(bool val) {
    isAddToCart = val;
  }

  @action
  void setReview(bool val) {
    isReview = val;
  }

  @action
  void setCartList(List<MyCartResponse> cartData) {
    cartList.addAll(cartData);
  }

  @action
  void setCartItem(MyCartResponse cartData) {
    cartList.add(cartData);
  }

  @action
  void removeCartList(List<MyCartResponse> cartData) {
    cartList.clear();
  }

  @action
  void removeCartItem(MyCartResponse cartData) {
    cartList.remove(cartData);
  }

  @action
  void addCartCount(String countId) {
    cartCount.add(countId);
  }

  @action
  void removeCartCount(String countId) {
    cartCount.remove(countId);
  }

  @action
  void setLanguage(String val) {
    selectedLanguage = val;
  }

  @action
  void setConnectionState(ConnectivityResult val) {
    connectivityResult = val;
  }

  @action
  void setDeviceId(String val) {
    deviceId = val;
  }

  @action
  Future<void> setUserName(String value) async {
    userName = value;
    await setValue(USERNAME, value);
  }

  @action
  Future<void> setToken(String value) async {
    token = value;
    await setValue(TOKEN, value);
  }

  @action
  Future<void> setFirstName(String value) async {
    firstName = value;
    await setValue(FIRST_NAME, value);
  }

  @action
  Future<void> setLastName(String value) async {
    lastName = value;
    await setValue(LAST_NAME, value);
  }

  @action
  Future<void> setDisplayName(String value) async {
    displayName = value;
    await setValue(USER_DISPLAY_NAME, value);
  }

  @action
  Future<void> setUserId(int value) async {
    userId = value;
    await setValue(USER_ID, value);
  }

  @action
  Future<void> setUserEmail(String value) async {
    userEmail = value;
    await setValue(USER_EMAIL, value);
  }

  @action
  Future<void> setAvatar(String value) async {
    avatar = value;
    await setValue(AVATAR, value);
  }

  @action
  Future<void> setFirstTime(bool value) async {
    isFirstTime = value;
    await setValue(IS_FIRST_TIME, value);
  }

  @action
  Future<void> setLoggedIn(bool value) async {
    isLoggedIn = value;
    await setValue(IS_LOGGED_IN, value);
  }

  @action
  Future<void> setProfileImage(String value) async {
    profileImage = value;
    await setValue(PROFILE_IMAGE, value);
  }

  @action
  Future<void> setPassword(String value) async {
    password = value;
    await setValue(PASSWORD, value);
  }

  @action
  Future<void> setSocialLogin(bool value) async {
    isSocialLogin = value;
    await setValue(IS_SOCIAL_LOGIN, value);
  }

  @action
  Future<void> setTokenExpired(bool value) async {
    isTokenExpired = value;
    await setValue(TOKEN_EXPIRED, value);
  }
}
