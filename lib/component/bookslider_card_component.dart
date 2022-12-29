import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/HeaderModel.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class BookSliderCardComponent extends StatefulWidget {
  static String tag = '/BookSliderCardComponent';
  final HeaderModel data;

  BookSliderCardComponent(this.data);

  @override
  BookSliderCardComponentState createState() => BookSliderCardComponentState();
}

class BookSliderCardComponentState extends State<BookSliderCardComponent> {
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
    return Column(
      children: <Widget>[
        Hero(
          tag: widget.data.title!,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: context.width() * 0.80,
              height: 320,
              padding: EdgeInsets.all(16),
              decoration: boxDecorationRoundedWithShadow(30,
                  backgroundColor: Colors.white,
                  gradient: LinearGradient(
                    begin: Alignment(6.123234262925839e-17, 1),
                    end: Alignment(-1, 6.123234262925839e-17),
                    colors: [
                      Color.fromRGBO(185, 205, 254, 1),
                      Color.fromRGBO(150, 172, 229, 1),
                    ],
                  ),
                  shadowColor: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.data.title.validate(), style: secondaryTextStyle(color: Colors.white)),
                  4.height,
                  AutoSizeText(
                    widget.data.message!,
                    textAlign: TextAlign.left,
                    style: boldTextStyle(size: 22, color: Colors.white),
                    maxLines: 1,
                  ),
                  32.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: new AlwaysStoppedAnimation(-15 / 360),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Center(child: bookLoaderWidget),
                          imageUrl: widget.data.image2,
                          fit: BoxFit.fill,
                          width: context.width() * 0.28,
                          height: context.width() * 0.40,
                        ),
                      ),
                      RotationTransition(
                        turns: new AlwaysStoppedAnimation(22 / 360),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Center(child: bookLoaderWidget),
                          imageUrl: widget.data.image1,
                          fit: BoxFit.fill,
                          width: context.width() * 0.28,
                          height: context.width() * 0.40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).paddingAll(12),
      ],
    );
  }
}
