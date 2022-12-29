import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterapp/model/HeaderModel.dart';
import 'package:flutterapp/screens/view_all_book_screen.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import 'bookslider_card_component.dart';

class BookStoreSliderComponent extends StatefulWidget {
  static String tag = '/BookStoreSliderComponent';
  final List<HeaderModel>? mHeaderModel;

  BookStoreSliderComponent({this.mHeaderModel});

  @override
  BookStoreSliderComponentState createState() => BookStoreSliderComponentState();
}

class BookStoreSliderComponentState extends State<BookStoreSliderComponent> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      child: PageView.builder(
          itemCount: widget.mHeaderModel!.length,
          physics: const ClampingScrollPhysics(),
          controller: _pageController,
          itemBuilder: (context, index) {
            HeaderModel mData = widget.mHeaderModel![index];
            return GestureDetector(
              child: carouselView(index),
              onTap: () {
                if (mData.type == BOOK_TYPE_NEW) {
                  ViewAllBooksScreen(title: keyString(context, "newest_books"), newestBook: true).launch(context);
                } else if (mData.type == BOOK_TYPE_FEATURED) {
                  ViewAllBooksScreen(title: keyString(context, "featured_books"), futureBook: true).launch(context);
                } else if (mData.type == BOOK_TYPE_SUGGESTION) {
                  ViewAllBooksScreen(title: keyString(context, "books_for_you"), suggestionBook: true).launch(context);
                } else if (mData.type == BOOK_TYPE_LIKE) {
                  ViewAllBooksScreen(title: keyString(context, "you_may_like"), youMayLikeBook: true).launch(context);
                }
              },
            );
          }),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.032).clamp(-1, 1);
        }
        return Transform.rotate(
          angle: pi * value,
          child: BookSliderCardComponent(widget.mHeaderModel![index]),
        );
      },
    );
  }
}
