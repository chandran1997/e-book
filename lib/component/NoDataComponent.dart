import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:nb_utils/nb_utils.dart';

class NoDataComponent extends StatefulWidget {
  static String tag = '/NoDataComponent';

  @override
  NoDataComponentState createState() => NoDataComponentState();
}

class NoDataComponentState extends State<NoDataComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: Container(height: context.height(), width: context.width()),
    );
  }
}
