import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import '../app_localizations.dart';
import '../main.dart';

// ignore: must_be_immutable
class BookAttributeComponent extends StatefulWidget {
  static String tag = '/BookAttributeComponent';
  var mBookDetailsData;
  final bool? checkVisible;
  var mSampleFile;

  BookAttributeComponent({this.mBookDetailsData, this.checkVisible, this.mSampleFile});

  @override
  BookAttributeComponentState createState() => BookAttributeComponentState();
}

class BookAttributeComponentState extends State<BookAttributeComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  // get Additional Information
  String getAllAttribute(Attributes attribute) {
    String attributes = "";
    for (var i = 0; i < attribute.options!.length; i++) {
      attributes = attributes + attribute.options![i];
      if (i < attribute.options!.length - 1) {
        attributes = attributes + ", ";
      }
    }
    return attributes;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          keyString(context, "lbl_additional_information")!,
          style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
        ).visible(isSingleSampleFile(widget.mBookDetailsData.attributes!.length, widget.mSampleFile) && widget.checkVisible == true).paddingOnly(left: 16, right: 16),
        Container(
          height: widget.mBookDetailsData.attributes!.length != null ? 120 : 0,
          child: ListView.builder(
            itemCount: widget.mBookDetailsData.attributes!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              toast(widget.mBookDetailsData.attributes![i].name);
              return Container(
                child: (widget.mBookDetailsData.attributes![i].name == SAMPLE_FILE && !widget.mBookDetailsData.attributes![i].visible)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mBookDetailsData.attributes![i].name! + " : ",
                            style: TextStyle(fontSize: fontSizeMedium, color: textSecondaryColor, fontWeight: FontWeight.bold),
                          ),
                          4.width,
                          Expanded(
                            child: Text(
                              getAllAttribute(widget.mBookDetailsData.attributes![i]),
                              style: TextStyle(fontSize: fontSizeMedium, color: textSecondaryColor),
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
              );
            },
          ).expand(),
        ),
      ],
    );
  }
}
