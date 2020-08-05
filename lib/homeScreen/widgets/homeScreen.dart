import 'dart:math';
import 'package:flutter/material.dart';
import 'package:launcher_helper/launcher_helper.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/storageService.dart';
import 'package:get_it/get_it.dart';

/// The main screen of the launcher. This screen contains 6 apps
/// that the user has chosen to be the most important.

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MediaQueryData mediaQuery;
  double width;
  double height;
  StorageService storage = locator<StorageService>();

  @override
  void initState() {
    super.initState();
  }

  Widget buildSingleApp({String packageName}) {
    double side = min((height / 4) - 30, (width / 2) - 30);
    if (packageName == null) {
      return Container(
        margin: const EdgeInsets.all(15.0),
        width: side,
        height: side,
      );
    }

    Application app = storage.getApp(packageName: packageName);

    return NeumorphicButton(
      onTap: () async {
        storage.increaseAppUsage(
          packageName: packageName,
        );
        LauncherHelper.launchApp(packageName);
      },
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      width: side,
      height: side,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicContainer(
            width: (side - 40) * 0.5,
            height: (side - 40) * 0.5,
            shape: BoxShape.circle,
            style: Style.emboss,
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              fit: BoxFit.fill,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: app.icon,
              ),
            ),
          ),
          Text(
            app.label ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height -
        mediaQuery.viewInsets.top -
        mediaQuery.padding.top -
        mediaQuery.viewInsets.bottom -
        mediaQuery.padding.bottom;

    List<String> packages =
        storage.getMostUsedApps(amount: 8).reversed.toList();

    return Material(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          width: width,
          child: Wrap(
            runAlignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              8,
              (i) => buildSingleApp(
                  packageName: packages.length - 1 >= i ? packages[i] : null),
            ),
          ),
        ),
      ),
    );
  }
}
