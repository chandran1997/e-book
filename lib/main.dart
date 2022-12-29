import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/model/DefaultSettingModel.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/splash_screen.dart';
import 'package:flutterapp/store/AppStore.dart';
import 'package:flutterapp/utils/AppTheme.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app_localizations.dart';
import 'model/MyCartResponse.dart';

late PackageInfoData packageInfo;
// Default Configuration
double bookViewHeight = mobile_BookViewHeight;
double bookHeight = mobile_bookHeight;
double bookWidth = mobile_bookWidth;
double appLoaderWH = mobile_appLoaderWH;
double backIconSize = mobile_backIconSize;
double bookHeightDetails = mobile_bookWidthDetails;
double bookWidthDetails = mobile_bookHeightDetails;
double fontSizeMedium = mobile_font_size_medium;
double fontSizeXxxlarge = mobile_font_size_xxxlarge;
double fontSizeMicro = mobile_font_size_micro;
double fontSize25 = mobile_font_size_25;

int mAdShowCount = 0;

List<MyCartResponse> myCartList = [];
AppStore appStore = AppStore();
String paystackPublicKey = PAYSTACK_PUBLIC_KEY;

List<DefaultSettingModel> getDefaultAnimation = DefaultSettingModel.getDefaultAnimation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    OneSignal.shared.setAppId(ONESIGNAL_ID).then((value) {
      OneSignal.shared.consentGranted(true);
      OneSignal.shared.promptUserForPushNotificationPermission();
      OneSignal.shared.userProvidedPrivacyConsent();
      OneSignal.shared.setLaunchURLsInApp(true);
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    });
  }).catchError((e) {
    log('Error : ${e.toString()}');
  });

  await initMethod();
  runApp(new MyApp());
}

Future<void> initMethod() async {
  forceEnableDebug = true;
  setOrientationPortrait();

  await initialize(aLocaleLanguageList: [
    LanguageDataModel(id: 1, languageCode: 'af'),
    LanguageDataModel(id: 2, languageCode: 'ar'),
    LanguageDataModel(id: 3, languageCode: 'de'),
    LanguageDataModel(id: 4, languageCode: 'en'),
    LanguageDataModel(id: 5, languageCode: 'es'),
    LanguageDataModel(id: 6, languageCode: 'fr'),
    LanguageDataModel(id: 7, languageCode: 'hi'),
    LanguageDataModel(id: 8, languageCode: 'in'),
    LanguageDataModel(id: 9, languageCode: 'tr'),
    LanguageDataModel(id: 10, languageCode: 'vi'),
    LanguageDataModel(id: 11, languageCode: 'zh'),
    LanguageDataModel(id: 12, languageCode: 'pt'),
  ]);

  packageInfo = await getPackageInfo();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: DEFAULT_LANGUAGE_CODE);
  if (selectedLanguageDataModel != null) {
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  } else {
    selectedLanguageDataModel = localeLanguageList.first;
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  }

  await appStore.setUserName(getStringAsync(USERNAME));
  await appStore.setToken(getStringAsync(TOKEN));
  await appStore.setFirstName(getStringAsync(FIRST_NAME));
  await appStore.setLastName(getStringAsync(LAST_NAME));
  await appStore.setDisplayName(getStringAsync(USER_DISPLAY_NAME));
  await appStore.setUserId(getIntAsync(USER_ID));
  await appStore.setUserEmail(getStringAsync(USER_EMAIL));
  await appStore.setAvatar(getStringAsync(AVATAR));
  await appStore.setFirstTime(getBoolAsync(IS_FIRST_TIME));
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  await appStore.setProfileImage(getStringAsync(PROFILE_IMAGE));
  await appStore.setPassword(getStringAsync(PASSWORD));
  await appStore.setSocialLogin(getBoolAsync(IS_SOCIAL_LOGIN));
  await appStore.setTokenExpired(getBoolAsync(TOKEN_EXPIRED));

  /*String? deviceId = await getId();
  appStore.setDeviceId(deviceId!);*/

  getCartItem();
}

Future<void> getCartItem() async {
  await getCartBook().then((value) {
    Iterable mCart = value;
    myCartList.clear();
    myCartList.addAll(mCart.map((model) => MyCartResponse.fromJson(model)).toList());
    myCartList.forEach((element) {
      appStore.addCartCount(element.proId.toString());
    });
  }).catchError((onError) {
    //
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
      appStore.setConnectionState(event);
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage),
        supportedLocales: LanguageDataModel.languageLocales(),
        home: SplashScreen(),
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
