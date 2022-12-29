import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/BookmarkResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class BookMarkListComponent extends StatefulWidget {
  static String tag = '/BookmarkBookList';
  final BookmarkResponse? bookData;
  final Color? borderColor;

  BookMarkListComponent(this.bookData, {this.borderColor});

  @override
  BookMarkListComponentState createState() => BookMarkListComponentState();
}

class BookMarkListComponentState extends State<BookMarkListComponent> {
  bool mIsFreeBook = false;
  bool mIsSalePrice = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getBookPrice();
  }

  Future getBookPrice() async {
    //if (widget.bookData!.price == "" && widget.bookData!.salePrice == "" && widget.bookData!.regularPrice == "") {
    if ((widget.bookData!.price.toString().isEmpty || widget.bookData!.price.toString() == "0") &&
            (widget.bookData!.salePrice.toString().isEmpty || widget.bookData!.salePrice.toString() == "0") &&
            widget.bookData!.regularPrice.toString().isEmpty ||
        widget.bookData!.regularPrice.toString() == "0") {
      mIsFreeBook = true;
    } else {
      mIsFreeBook = false;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          child: CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: Container(height: 100, width: 80, child: bookLoaderWidget),
            ),
            imageUrl: widget.bookData!.full.validate(),
            fit: BoxFit.cover,
            height: 100,
            width: 80,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bookData!.name.validate(), style: boldTextStyle()),
            Text(keyString(context, 'lbl_free')!, style: boldTextStyle(color: Colors.green)).visible(mIsFreeBook),
            salePriceWidget(salePrice: widget.bookData!.salePrice.validate(), regularPrice: widget.bookData!.regularPrice.validate()).visible(
              widget.bookData!.regularPrice.toString().isNotEmpty || widget.bookData!.salePrice.toString().isNotEmpty,
            )
          ],
        ),
      ],
    );
  }
}
