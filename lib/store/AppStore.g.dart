// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  Computed<bool>? _$isNetworkConnectedComputed;

  @override
  bool get isNetworkConnected => (_$isNetworkConnectedComputed ??=
          Computed<bool>(() => super.isNetworkConnected,
              name: 'AppStoreBase.isNetworkConnected'))
      .value;

  late final _$isDarkModeOnAtom =
      Atom(name: 'AppStoreBase.isDarkModeOn', context: context);

  @override
  bool get isDarkModeOn {
    _$isDarkModeOnAtom.reportRead();
    return super.isDarkModeOn;
  }

  @override
  set isDarkModeOn(bool value) {
    _$isDarkModeOnAtom.reportWrite(value, super.isDarkModeOn, () {
      super.isDarkModeOn = value;
    });
  }

  late final _$scaffoldBackgroundAtom =
      Atom(name: 'AppStoreBase.scaffoldBackground', context: context);

  @override
  Color? get scaffoldBackground {
    _$scaffoldBackgroundAtom.reportRead();
    return super.scaffoldBackground;
  }

  @override
  set scaffoldBackground(Color? value) {
    _$scaffoldBackgroundAtom.reportWrite(value, super.scaffoldBackground, () {
      super.scaffoldBackground = value;
    });
  }

  late final _$backgroundColorAtom =
      Atom(name: 'AppStoreBase.backgroundColor', context: context);

  @override
  Color? get backgroundColor {
    _$backgroundColorAtom.reportRead();
    return super.backgroundColor;
  }

  @override
  set backgroundColor(Color? value) {
    _$backgroundColorAtom.reportWrite(value, super.backgroundColor, () {
      super.backgroundColor = value;
    });
  }

  late final _$backgroundSecondaryColorAtom =
      Atom(name: 'AppStoreBase.backgroundSecondaryColor', context: context);

  @override
  Color? get backgroundSecondaryColor {
    _$backgroundSecondaryColorAtom.reportRead();
    return super.backgroundSecondaryColor;
  }

  @override
  set backgroundSecondaryColor(Color? value) {
    _$backgroundSecondaryColorAtom
        .reportWrite(value, super.backgroundSecondaryColor, () {
      super.backgroundSecondaryColor = value;
    });
  }

  late final _$appTextPrimaryColorAtom =
      Atom(name: 'AppStoreBase.appTextPrimaryColor', context: context);

  @override
  Color? get appTextPrimaryColor {
    _$appTextPrimaryColorAtom.reportRead();
    return super.appTextPrimaryColor;
  }

  @override
  set appTextPrimaryColor(Color? value) {
    _$appTextPrimaryColorAtom.reportWrite(value, super.appTextPrimaryColor, () {
      super.appTextPrimaryColor = value;
    });
  }

  late final _$editTextBackColorAtom =
      Atom(name: 'AppStoreBase.editTextBackColor', context: context);

  @override
  Color? get editTextBackColor {
    _$editTextBackColorAtom.reportRead();
    return super.editTextBackColor;
  }

  @override
  set editTextBackColor(Color? value) {
    _$editTextBackColorAtom.reportWrite(value, super.editTextBackColor, () {
      super.editTextBackColor = value;
    });
  }

  late final _$appColorPrimaryLightColorAtom =
      Atom(name: 'AppStoreBase.appColorPrimaryLightColor', context: context);

  @override
  Color? get appColorPrimaryLightColor {
    _$appColorPrimaryLightColorAtom.reportRead();
    return super.appColorPrimaryLightColor;
  }

  @override
  set appColorPrimaryLightColor(Color? value) {
    _$appColorPrimaryLightColorAtom
        .reportWrite(value, super.appColorPrimaryLightColor, () {
      super.appColorPrimaryLightColor = value;
    });
  }

  late final _$textSecondaryColorAtom =
      Atom(name: 'AppStoreBase.textSecondaryColor', context: context);

  @override
  Color? get textSecondaryColor {
    _$textSecondaryColorAtom.reportRead();
    return super.textSecondaryColor;
  }

  @override
  set textSecondaryColor(Color? value) {
    _$textSecondaryColorAtom.reportWrite(value, super.textSecondaryColor, () {
      super.textSecondaryColor = value;
    });
  }

  late final _$appBarColorAtom =
      Atom(name: 'AppStoreBase.appBarColor', context: context);

  @override
  Color? get appBarColor {
    _$appBarColorAtom.reportRead();
    return super.appBarColor;
  }

  @override
  set appBarColor(Color? value) {
    _$appBarColorAtom.reportWrite(value, super.appBarColor, () {
      super.appBarColor = value;
    });
  }

  late final _$iconColorAtom =
      Atom(name: 'AppStoreBase.iconColor', context: context);

  @override
  Color? get iconColor {
    _$iconColorAtom.reportRead();
    return super.iconColor;
  }

  @override
  set iconColor(Color? value) {
    _$iconColorAtom.reportWrite(value, super.iconColor, () {
      super.iconColor = value;
    });
  }

  late final _$iconSecondaryColorAtom =
      Atom(name: 'AppStoreBase.iconSecondaryColor', context: context);

  @override
  Color? get iconSecondaryColor {
    _$iconSecondaryColorAtom.reportRead();
    return super.iconSecondaryColor;
  }

  @override
  set iconSecondaryColor(Color? value) {
    _$iconSecondaryColorAtom.reportWrite(value, super.iconSecondaryColor, () {
      super.iconSecondaryColor = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: 'AppStoreBase.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$selectedDrawerItemAtom =
      Atom(name: 'AppStoreBase.selectedDrawerItem', context: context);

  @override
  int get selectedDrawerItem {
    _$selectedDrawerItemAtom.reportRead();
    return super.selectedDrawerItem;
  }

  @override
  set selectedDrawerItem(int value) {
    _$selectedDrawerItemAtom.reportWrite(value, super.selectedDrawerItem, () {
      super.selectedDrawerItem = value;
    });
  }

  late final _$languageCodeAtom =
      Atom(name: 'AppStoreBase.languageCode', context: context);

  @override
  List<String> get languageCode {
    _$languageCodeAtom.reportRead();
    return super.languageCode;
  }

  @override
  set languageCode(List<String> value) {
    _$languageCodeAtom.reportWrite(value, super.languageCode, () {
      super.languageCode = value;
    });
  }

  late final _$isRTLAtom = Atom(name: 'AppStoreBase.isRTL', context: context);

  @override
  bool get isRTL {
    _$isRTLAtom.reportRead();
    return super.isRTL;
  }

  @override
  set isRTL(bool value) {
    _$isRTLAtom.reportWrite(value, super.isRTL, () {
      super.isRTL = value;
    });
  }

  late final _$pageAtom = Atom(name: 'AppStoreBase.page', context: context);

  @override
  int? get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int? value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'AppStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isAddToCartAtom =
      Atom(name: 'AppStoreBase.isAddToCart', context: context);

  @override
  bool get isAddToCart {
    _$isAddToCartAtom.reportRead();
    return super.isAddToCart;
  }

  @override
  set isAddToCart(bool value) {
    _$isAddToCartAtom.reportWrite(value, super.isAddToCart, () {
      super.isAddToCart = value;
    });
  }

  late final _$isReviewAtom =
      Atom(name: 'AppStoreBase.isReview', context: context);

  @override
  bool get isReview {
    _$isReviewAtom.reportRead();
    return super.isReview;
  }

  @override
  set isReview(bool value) {
    _$isReviewAtom.reportWrite(value, super.isReview, () {
      super.isReview = value;
    });
  }

  late final _$cartListAtom =
      Atom(name: 'AppStoreBase.cartList', context: context);

  @override
  List<MyCartResponse> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(List<MyCartResponse> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  late final _$cartCountAtom =
      Atom(name: 'AppStoreBase.cartCount', context: context);

  @override
  List<String> get cartCount {
    _$cartCountAtom.reportRead();
    return super.cartCount;
  }

  @override
  set cartCount(List<String> value) {
    _$cartCountAtom.reportWrite(value, super.cartCount, () {
      super.cartCount = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: 'AppStoreBase.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$connectivityResultAtom =
      Atom(name: 'AppStoreBase.connectivityResult', context: context);

  @override
  ConnectivityResult get connectivityResult {
    _$connectivityResultAtom.reportRead();
    return super.connectivityResult;
  }

  @override
  set connectivityResult(ConnectivityResult value) {
    _$connectivityResultAtom.reportWrite(value, super.connectivityResult, () {
      super.connectivityResult = value;
    });
  }

  late final _$deviceIdAtom =
      Atom(name: 'AppStoreBase.deviceId', context: context);

  @override
  String get deviceId {
    _$deviceIdAtom.reportRead();
    return super.deviceId;
  }

  @override
  set deviceId(String value) {
    _$deviceIdAtom.reportWrite(value, super.deviceId, () {
      super.deviceId = value;
    });
  }

  late final _$userNameAtom =
      Atom(name: 'AppStoreBase.userName', context: context);

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  late final _$tokenAtom = Atom(name: 'AppStoreBase.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$firstNameAtom =
      Atom(name: 'AppStoreBase.firstName', context: context);

  @override
  String get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  late final _$lastNameAtom =
      Atom(name: 'AppStoreBase.lastName', context: context);

  @override
  String get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  late final _$displayNameAtom =
      Atom(name: 'AppStoreBase.displayName', context: context);

  @override
  String get displayName {
    _$displayNameAtom.reportRead();
    return super.displayName;
  }

  @override
  set displayName(String value) {
    _$displayNameAtom.reportWrite(value, super.displayName, () {
      super.displayName = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: 'AppStoreBase.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$profileImageAtom =
      Atom(name: 'AppStoreBase.profileImage', context: context);

  @override
  String get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(String value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  late final _$userIdAtom = Atom(name: 'AppStoreBase.userId', context: context);

  @override
  int get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$avatarAtom = Atom(name: 'AppStoreBase.avatar', context: context);

  @override
  String get avatar {
    _$avatarAtom.reportRead();
    return super.avatar;
  }

  @override
  set avatar(String value) {
    _$avatarAtom.reportWrite(value, super.avatar, () {
      super.avatar = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: 'AppStoreBase.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$isFirstTimeAtom =
      Atom(name: 'AppStoreBase.isFirstTime', context: context);

  @override
  bool get isFirstTime {
    _$isFirstTimeAtom.reportRead();
    return super.isFirstTime;
  }

  @override
  set isFirstTime(bool value) {
    _$isFirstTimeAtom.reportWrite(value, super.isFirstTime, () {
      super.isFirstTime = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: 'AppStoreBase.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isSocialLoginAtom =
      Atom(name: 'AppStoreBase.isSocialLogin', context: context);

  @override
  bool get isSocialLogin {
    _$isSocialLoginAtom.reportRead();
    return super.isSocialLogin;
  }

  @override
  set isSocialLogin(bool value) {
    _$isSocialLoginAtom.reportWrite(value, super.isSocialLogin, () {
      super.isSocialLogin = value;
    });
  }

  late final _$isTokenExpiredAtom =
      Atom(name: 'AppStoreBase.isTokenExpired', context: context);

  @override
  bool get isTokenExpired {
    _$isTokenExpiredAtom.reportRead();
    return super.isTokenExpired;
  }

  @override
  set isTokenExpired(bool value) {
    _$isTokenExpiredAtom.reportWrite(value, super.isTokenExpired, () {
      super.isTokenExpired = value;
    });
  }

  late final _$toggleDarkModeAsyncAction =
      AsyncAction('AppStoreBase.toggleDarkMode', context: context);

  @override
  Future<void> toggleDarkMode({bool? value}) {
    return _$toggleDarkModeAsyncAction
        .run(() => super.toggleDarkMode(value: value));
  }

  late final _$checkRTLAsyncAction =
      AsyncAction('AppStoreBase.checkRTL', context: context);

  @override
  Future<void> checkRTL({String? value}) {
    return _$checkRTLAsyncAction.run(() => super.checkRTL(value: value));
  }

  late final _$setUserNameAsyncAction =
      AsyncAction('AppStoreBase.setUserName', context: context);

  @override
  Future<void> setUserName(String value) {
    return _$setUserNameAsyncAction.run(() => super.setUserName(value));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('AppStoreBase.setToken', context: context);

  @override
  Future<void> setToken(String value) {
    return _$setTokenAsyncAction.run(() => super.setToken(value));
  }

  late final _$setFirstNameAsyncAction =
      AsyncAction('AppStoreBase.setFirstName', context: context);

  @override
  Future<void> setFirstName(String value) {
    return _$setFirstNameAsyncAction.run(() => super.setFirstName(value));
  }

  late final _$setLastNameAsyncAction =
      AsyncAction('AppStoreBase.setLastName', context: context);

  @override
  Future<void> setLastName(String value) {
    return _$setLastNameAsyncAction.run(() => super.setLastName(value));
  }

  late final _$setDisplayNameAsyncAction =
      AsyncAction('AppStoreBase.setDisplayName', context: context);

  @override
  Future<void> setDisplayName(String value) {
    return _$setDisplayNameAsyncAction.run(() => super.setDisplayName(value));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('AppStoreBase.setUserId', context: context);

  @override
  Future<void> setUserId(int value) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(value));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('AppStoreBase.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String value) {
    return _$setUserEmailAsyncAction.run(() => super.setUserEmail(value));
  }

  late final _$setAvatarAsyncAction =
      AsyncAction('AppStoreBase.setAvatar', context: context);

  @override
  Future<void> setAvatar(String value) {
    return _$setAvatarAsyncAction.run(() => super.setAvatar(value));
  }

  late final _$setFirstTimeAsyncAction =
      AsyncAction('AppStoreBase.setFirstTime', context: context);

  @override
  Future<void> setFirstTime(bool value) {
    return _$setFirstTimeAsyncAction.run(() => super.setFirstTime(value));
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('AppStoreBase.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool value) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(value));
  }

  late final _$setProfileImageAsyncAction =
      AsyncAction('AppStoreBase.setProfileImage', context: context);

  @override
  Future<void> setProfileImage(String value) {
    return _$setProfileImageAsyncAction.run(() => super.setProfileImage(value));
  }

  late final _$setPasswordAsyncAction =
      AsyncAction('AppStoreBase.setPassword', context: context);

  @override
  Future<void> setPassword(String value) {
    return _$setPasswordAsyncAction.run(() => super.setPassword(value));
  }

  late final _$setSocialLoginAsyncAction =
      AsyncAction('AppStoreBase.setSocialLogin', context: context);

  @override
  Future<void> setSocialLogin(bool value) {
    return _$setSocialLoginAsyncAction.run(() => super.setSocialLogin(value));
  }

  late final _$setTokenExpiredAsyncAction =
      AsyncAction('AppStoreBase.setTokenExpired', context: context);

  @override
  Future<void> setTokenExpired(bool value) {
    return _$setTokenExpiredAsyncAction.run(() => super.setTokenExpired(value));
  }

  late final _$AppStoreBaseActionController =
      ActionController(name: 'AppStoreBase', context: context);

  @override
  void setDrawerItemIndex(int aIndex) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setDrawerItemIndex');
    try {
      return super.setDrawerItemIndex(aIndex);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int? aIndex) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setPage');
    try {
      return super.setPage(aIndex);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddToCart(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setAddToCart');
    try {
      return super.setAddToCart(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReview(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setReview');
    try {
      return super.setReview(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCartList(List<MyCartResponse> cartData) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setCartList');
    try {
      return super.setCartList(cartData);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCartItem(MyCartResponse cartData) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setCartItem');
    try {
      return super.setCartItem(cartData);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCartList(List<MyCartResponse> cartData) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.removeCartList');
    try {
      return super.removeCartList(cartData);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCartItem(MyCartResponse cartData) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.removeCartItem');
    try {
      return super.removeCartItem(cartData);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCartCount(String countId) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.addCartCount');
    try {
      return super.addCartCount(countId);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCartCount(String countId) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.removeCartCount');
    try {
      return super.removeCartCount(countId);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLanguage(String val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLanguage');
    try {
      return super.setLanguage(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConnectionState(ConnectivityResult val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setConnectionState');
    try {
      return super.setConnectionState(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeviceId(String val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setDeviceId');
    try {
      return super.setDeviceId(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDarkModeOn: ${isDarkModeOn},
scaffoldBackground: ${scaffoldBackground},
backgroundColor: ${backgroundColor},
backgroundSecondaryColor: ${backgroundSecondaryColor},
appTextPrimaryColor: ${appTextPrimaryColor},
editTextBackColor: ${editTextBackColor},
appColorPrimaryLightColor: ${appColorPrimaryLightColor},
textSecondaryColor: ${textSecondaryColor},
appBarColor: ${appBarColor},
iconColor: ${iconColor},
iconSecondaryColor: ${iconSecondaryColor},
selectedLanguage: ${selectedLanguage},
selectedDrawerItem: ${selectedDrawerItem},
languageCode: ${languageCode},
isRTL: ${isRTL},
page: ${page},
isLoading: ${isLoading},
isAddToCart: ${isAddToCart},
isReview: ${isReview},
cartList: ${cartList},
cartCount: ${cartCount},
selectedLanguageCode: ${selectedLanguageCode},
connectivityResult: ${connectivityResult},
deviceId: ${deviceId},
userName: ${userName},
token: ${token},
firstName: ${firstName},
lastName: ${lastName},
displayName: ${displayName},
userEmail: ${userEmail},
profileImage: ${profileImage},
userId: ${userId},
avatar: ${avatar},
password: ${password},
isFirstTime: ${isFirstTime},
isLoggedIn: ${isLoggedIn},
isSocialLogin: ${isSocialLogin},
isTokenExpired: ${isTokenExpired},
isNetworkConnected: ${isNetworkConnected}
    ''';
  }
}
