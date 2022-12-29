import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/utils/admob_utils.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/images.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class AboutUsScreen extends StatefulWidget {
  static var tag = "/AboutUs";

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String? copyrightText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    setState(() {
      if (getStringAsync(COPYRIGHT_TEXT).isNotEmpty) {
        copyrightText = getStringAsync(COPYRIGHT_TEXT);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, "lbl_about")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: boxDecoration(radius: defaultRadius),
            child: Image.asset(ic_logo),
          ),
          16.height,
          Text(packageInfo.appName.toString(), style: boldTextStyle(color: PRIMARY_COLOR, size: 20)),
          Text(packageInfo.versionName.toString(), style: secondaryTextStyle()),
          16.height,
          AppButton(
            color: PRIMARY_COLOR,
            textStyle: boldTextStyle(color: Colors.white),
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            text: keyString(context, 'lbl_purchase'),
            onTap: () {
              launchUrl(
                Uri.parse("https://codecanyon.net/item/bookkart-flutter-ebook-reader-app-for-wordpress-with-woocommerce/28780154?s_rank=13"),
                mode: LaunchMode.externalApplication,
              );
            },
          )
        ],
      ).center(),
      bottomNavigationBar: Container(
        width: context.width(),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(keyString(context, 'llb_follow_us')!, style: boldTextStyle()).visible(getStringAsync(WHATSAPP).isNotEmpty),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                16.width,
                InkWell(
                  onTap: () => commonLaunchUrl('${getStringAsync(WHATSAPP)}'),
                  child: Image.asset("ic_Whatsapp.png", height: 35, width: 35).paddingAll(10),
                ).visible(getStringAsync(WHATSAPP).isNotEmpty),
                InkWell(
                  onTap: () => commonLaunchUrl(getStringAsync(INSTAGRAM)),
                  child: Image.asset("ic_Inst.png", height: 35, width: 35).paddingAll(10),
                ).visible(getStringAsync(INSTAGRAM).isNotEmpty),
                InkWell(
                  onTap: () => commonLaunchUrl(getStringAsync(TWITTER)),
                  child: Image.asset("ic_Twitter.png", height: 35, width: 35).paddingAll(10),
                ).visible(getStringAsync(TWITTER).isNotEmpty),
                InkWell(
                  onTap: () => commonLaunchUrl(getStringAsync(FACEBOOK)),
                  child: Image.asset("ic_Fb.png", height: 35, width: 35).paddingAll(10),
                ).visible(getStringAsync(FACEBOOK).isNotEmpty),
                InkWell(
                  onTap: () => commonLaunchUrl('${getStringAsync(CONTACT)}'),
                  child: Image.asset("ic_CallRing.png", height: 35, width: 35, color: PRIMARY_COLOR).paddingAll(10),
                ).visible(getStringAsync(CONTACT).isNotEmpty),
                16.width
              ],
            ),
            Text(copyrightText!, style: secondaryTextStyle()),
            4.height,
            Container(
              height: AdSize.banner.height.toDouble(),
              child: AdWidget(
                ad: BannerAd(
                  adUnitId: getBannerAdUnitId()!,
                  size: AdSize.banner,
                  request: AdRequest(),
                  listener: BannerAdListener(),
                )..load(),
              ).visible(isAdsLoading == true),
            ),
          ],
        ),
      ),
    );
  }
}
