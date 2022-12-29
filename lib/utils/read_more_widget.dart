import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:nb_utils/nb_utils.dart';

class ReadMoreWidget extends StatefulWidget {
  static String tag = '/MoreWidget';
  final String? text;

  ReadMoreWidget({this.text});

  @override
  ReadMoreWidgetState createState() => ReadMoreWidgetState();
}

class ReadMoreWidgetState extends State<ReadMoreWidget> {
  String? firstHalf;
  String? secondHalf;
  bool isReadMore = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.text!.length > 100) {
      firstHalf = widget.text!.substring(0, 100);
      secondHalf = widget.text!.substring(100, widget.text!.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: secondHalf!.isEmpty
          ? Text(firstHalf!, style: primaryTextStyle())
          : new Column(
              children: <Widget>[
                Text(isReadMore ? (firstHalf! + "...") : (firstHalf! + secondHalf!), style: primaryTextStyle()),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(isReadMore ? keyString(context, 'show more')! : keyString(context, 'lbl_show_less')!, style: primaryTextStyle(color: PRIMARY_COLOR)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      isReadMore = !isReadMore;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
