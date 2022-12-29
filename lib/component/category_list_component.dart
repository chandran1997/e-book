import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/model/CategoriesListResponse.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class CategoryListComponent extends StatefulWidget {
  CategoriesListResponse categoriesListResponse;

  CategoryListComponent(this.categoriesListResponse);

  @override
  _CategoryListComponentState createState() => _CategoryListComponentState();
}

class _CategoryListComponentState extends State<CategoryListComponent> {
  @override
  Widget build(BuildContext context) {
    return Html(
      data: widget.categoriesListResponse.name,
      style: {
        "body": Style(
          fontSize: FontSize(20),
          color: appStore.appTextPrimaryColor,
          margin: Margins.zero,
          padding: EdgeInsets.zero,
        ),
      },
    ).paddingSymmetric(vertical: 12);
  }
}
