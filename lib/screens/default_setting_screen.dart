import 'package:flutter/material.dart';
import 'package:flutterapp/model/DefaultSettingModel.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import '../main.dart';

class DefaultSettingScreen extends StatefulWidget {
  static String tag = '/DefaultSettingScreen';

  @override
  DefaultSettingScreenState createState() => DefaultSettingScreenState();
}

class DefaultSettingScreenState extends State<DefaultSettingScreen> {
  int animationTypeIndex = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    animationTypeIndex = getIntAsync(ANIMATION_TYPE_SELECTION_INDEX);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: appStore.appBarColor,
        elevation: 0,
        title: Row(
          children: [
            Text(keyString(context, 'lbl_default_settings')!, style: boldTextStyle(size: 20)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingSection(
              headerPadding: EdgeInsets.only(left: 16),
              headingDecoration: BoxDecoration(color: Colors.transparent),
              divider: Offstage(),
              title: Text(keyString(context, 'lbl_choose_animation')!, style: boldTextStyle(size: 18)),
              items: [
                Wrap(
                  runSpacing: 8,
                  spacing: 16,
                  children: List.generate(getDefaultAnimation.length, (index) {
                    DefaultSettingModel data = getDefaultAnimation[index];
                    bool isSelected = animationTypeIndex == index;
                    return SettingItemWidget(
                      onTap: () {
                        setValue(ANIMATION_TYPE_SELECTION_INDEX, index);
                        animationTypeIndex = index;
                        setState(() {});
                      },
                      title: '${data.name.validate()}',
                      titleTextStyle: primaryTextStyle(),
                      trailing: isSelected.validate()
                          ? AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle),
                              child: Icon(Icons.check, color: PRIMARY_COLOR, size: 20),
                            )
                          : Offstage(),
                    );
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
