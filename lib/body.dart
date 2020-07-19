import 'package:flutter/material.dart';
import 'package:thelauncher/homeScreen/widgets/homeScreen.dart';

/// The body of this launcher. By default displays the main screen of the launcher,
/// but also handles all the swiping gestures etc...

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(initialPage: 1),
      children: [
        // widgets page
        buildPage(Colors.blue),

        PageView(
          scrollDirection: Axis.vertical,
          controller: PageController(initialPage: 1),
          children: [
            //search page
            buildPage(Colors.red),
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
  }
}
