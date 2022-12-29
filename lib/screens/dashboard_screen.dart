import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/view/BookStoreView.dart';
import 'package:flutterapp/view/MyLibraryView.dart';
import 'package:flutterapp/view/SearchView.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/NoDataComponent.dart';
import 'Libaryscreen.dart';
import 'NoInternetConnection.dart';
import 'category_list_screen.dart';
import 'my_cart_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentPage = 0;

  List<Widget> tabs = [
    BookStoreView(),
    appStore.isLoggedIn ? MyLibraryView() : CategoriesListScreen(isShowBack: false),
    SearchView(),
  ];

  List<Widget> tabs1 = [
    appStore.isLoggedIn ? OfflineScreen(isShowBack: false) : NoInternetConnection(isCloseApp: true),
    NoDataComponent(),
    NoDataComponent(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void changePage(int index) {
    if (index == 1) {
      LiveStream().emit(REFRESH_LIST);
    }
    currentPage = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: () async {
                      MyCartScreen(isDescription: true).launch(context);
                    },
                    icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: redColor),
                    child: Text(
                      appStore.cartCount.length.toString(),
                      style: primaryTextStyle(size: 12, color: white),
                    ).paddingAll(4),
                  )
                ],
              ),
              onPressed: () {
                if (appStore.isLoggedIn) {
                  MyCartScreen().launch(context);
                }
              },
            ).visible(appStore.cartCount.length > 0 && appStore.isLoggedIn),
            body: IndexedStack(children: !appStore.isNetworkConnected ? tabs1 : tabs, index: currentPage),
            bottomNavigationBar: Observer(
              builder: (_) => BottomNavigationBar(
                currentIndex: currentPage,
                backgroundColor: appStore.scaffoldBackground,
                selectedItemColor: PRIMARY_COLOR,
                unselectedItemColor: appStore.isDarkModeOn ? white : black,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                onTap: changePage,
                selectedLabelStyle: TextStyle(color: PRIMARY_COLOR),
                type: BottomNavigationBarType.fixed,
                items: [
                  bottomNavigationBarItem("assets/home_icon.png", keyString(context, "title_bookStore")!),
                  bottomNavigationBarItem("assets/library_icon.png", appStore.isLoggedIn ? keyString(context, "title_myLibrary")! : keyString(context, "lbl_categories")!),
                  bottomNavigationBarItem("assets/search_icon.png", keyString(context, "title_search")!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
