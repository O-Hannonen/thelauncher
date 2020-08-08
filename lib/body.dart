import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thelauncher/homeScreen/widgets/homeScreen.dart';
import 'package:thelauncher/reusableWidgets/inputField.dart';
import 'package:get/get.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/searchPage/widgets/searchPage.dart';
import 'contactsPage/widgets/contactPage.dart';
import 'newsScreen/widgets/newsScreen.dart';
import 'package:permission_handler/permission_handler.dart';

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
  int verticalPage = 1;
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
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
      Get.to(
        SearchPage(),
        duration: Duration(milliseconds: 150),
        transition: Transition.noTransition,
      );
    }
    if (verticalController.offset >= mediaQuery.size.height + 100) {
      verticalController.animateToPage(
        1,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
      Get.to(
        ContactPage(),
        duration: Duration(milliseconds: 150),
        transition: Transition.noTransition,
      );
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
    return Material(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder<bool>(
          future: Permission.contacts.request().isGranted,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Container(
                  width: Get.width * 0.15,
                  height: Get.width * 0.15,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.data == false) {
              return NeumorphicButton(
                onTap: () {
                  openAppSettings();
                },
                child: Text(
                  "Give permission to contacts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }

            return PageView(
              scrollDirection: Axis.horizontal,
              physics:
                  verticalPage == 1 ? null : NeverScrollableScrollPhysics(),
              controller: horizontalController,
              children: [
                // widgets page
                buildPage(Colors.blue),

                PageView(
                  scrollDirection: Axis.vertical,
                  controller: verticalController,
                  onPageChanged: (page) {
                    setState(() {
                      verticalPage = page;
                    });
                  },
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
                    Container(),
                  ],
                ),
                // news page
                NewsScreen(),
              ],
            );
          }),
    );
  }
}
