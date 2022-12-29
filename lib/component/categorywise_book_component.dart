import 'package:flutter/material.dart';
import 'package:flutterapp/component/category_book_componenet.dart';
import 'package:flutterapp/model/DashboardResponse.dart';

class CategoryWiseBookComponent extends StatefulWidget {
  static String tag = '/CategoryWiseBookComponent';

  final List<Category>? mCategoryList;

  CategoryWiseBookComponent({this.mCategoryList});

  @override
  CategoryWiseBookComponentState createState() => CategoryWiseBookComponentState();
}

class CategoryWiseBookComponentState extends State<CategoryWiseBookComponent> {
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
    return ListView.builder(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, _index) {
        Category mData = widget.mCategoryList![_index];
        return CategoryBookComponent(categoryBookData: mData);
      },
      itemCount: widget.mCategoryList!.length,
      shrinkWrap: true,
    );
  }
}
