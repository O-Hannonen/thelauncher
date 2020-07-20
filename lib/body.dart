import 'package:flutter/material.dart';
import 'package:thelauncher/homeScreen/widgets/homeScreen.dart';
import 'package:thelauncher/reusableWidgets/inputField.dart';
import 'package:get/get.dart';
import 'package:thelauncher/searchPage/widgets/searchPage.dart';
import 'package:thelauncher/services/service_locator.dart';

/// The body of this launcher. By default displays the main screen of the launcher,
/// but also handles all the swiping gestures etc...

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController verticalController;
  PageController horizontalController;
  MediaQueryData mediaQuery;

  @override
  void initState() {
    super.initState();
    verticalController = PageController(initialPage: 1);
    horizontalController = PageController(initialPage: 1);
    verticalController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (verticalController.offset <=
        mediaQuery.size.height -
            mediaQuery.viewPadding.top -
            mediaQuery.size.width * 0.15 -
            30) {
      verticalController.animateToPage(
        1,
        duration: Duration(milliseconds: 150),
        curve: Curves.ease,
      );
      Get.to(SearchPage(), duration: Duration(milliseconds: 0));
    }
  }

  @override
  void dispose() {
    verticalController.dispose();
    horizontalController.dispose();

    super.dispose();
  }

  Widget buildPage(Color color) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: locator.allReady(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          print("waiting for locator to be ready");
          return Material(
            color: Theme.of(context).backgroundColor,
          );
        }

        print("building pageview");
        return PageView(
          scrollDirection: Axis.horizontal,
          controller: horizontalController,
          children: [
            // widgets page
            buildPage(Colors.blue),

            PageView(
              scrollDirection: Axis.vertical,
              controller: verticalController,
              children: [
                //search page
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Hero(
                        tag: "searchInput",
                        child: InputField(
                          title: "Search",
                        ),
                      ),
                    ],
                  ),
                ),
                // home screen
                HomeScreen(),
                // contacts
                buildPage(Colors.orange),
              ],
            ),
            // news page
            buildPage(Colors.yellow),
          ],
        );
      },
    );
  }
}