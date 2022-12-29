import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughComponent extends StatelessWidget {
  final String? textContent;
  final String? walkImg;
  final String? desc;

  WalkThroughComponent({Key? key, this.textContent, this.walkImg, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: context.height() * 0.05),
          height: context.height() * 0.5,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[Image.asset(walkImg!, width: context.width() * 0.8, height: context.height() * 0.4)],
          ),
        ),
        SizedBox(height: context.height() * 0.08),
        Text(textContent!, style: boldTextStyle(size: 20)),
        Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.0),
          child: Text(desc!, maxLines: 3, textAlign: TextAlign.center, style: primaryTextStyle(size: 16)),
        )
      ],
    );
  }
}
