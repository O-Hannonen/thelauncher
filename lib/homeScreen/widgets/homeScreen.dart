import 'dart:math';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';

/// The main screen of the launcher. This screen contains 6 apps
/// that the user has chosen to be the most important.

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MediaQueryData mediaQuery;
  double appSideWidth;

  Widget buildSingleApp({dynamic app}) {
    return GestureDetector(
      onTap: () async {
        await DeviceApps.openApp(app.packageName);
      },
      child: NeumorphicContainer(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(15.0),
        width: appSideWidth,
        height: appSideWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicContainer(
              width: (appSideWidth - 40) * 0.5,
              height: (appSideWidth - 40) * 0.5,
              shape: BoxShape.circle,
              style: Style.emboss,
              margin: const EdgeInsets.all(5.0),
              //   padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation,
                    ),
                    child: Image.memory(
                      app.icon,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              app.appName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    final w1 = mediaQuery.size.width * 0.5 - 30;
    final w2 = ((mediaQuery.size.height -
                mediaQuery.viewInsets.top -
                mediaQuery.padding.top -
                mediaQuery.viewInsets.bottom -
                mediaQuery.padding.bottom) /
            3) -
        30;

    appSideWidth = min(w1, w2);

    return Material(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder<List>(
        future: DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeAppIcons: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }

          List apps = snapshot.data.take(6).toList();

          return GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: apps
                .map(
                  (app) => buildSingleApp(
                    app: app,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
