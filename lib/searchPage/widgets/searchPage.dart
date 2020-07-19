import 'dart:math';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/inputField.dart';
import 'package:device_apps/device_apps.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic> apps;
  List filteredApps;
  TextEditingController searchController;
  MediaQueryData mediaQuery;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<bool> getApps() async {
    if (apps != null) {
      return true;
    }

    apps = {};

    filteredApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
    );

    filteredApps.forEach((app) {
      apps[app.appName.toLowerCase()] = app;
    });

    filteredApps.sort((s1, s2) => s1.appName.compareTo(s2.appName));

    return true;
  }

  Widget buildSingleApp({dynamic app}) {
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    double side = min((height / 4) - 30, (width / 2) - 30);
    if (app == null) {
      return Container(
        margin: const EdgeInsets.all(15.0),
        width: side,
        height: side,
      );
    }

    return GestureDetector(
      onTap: () async {
        await DeviceApps.openApp(app.packageName);
      },
      child: NeumorphicContainer(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Image.memory(
                    app.icon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              app.appName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void search() async {
    if (apps == null) {
      await getApps();
    }

    filteredApps.clear();

    String search = searchController.text.toLowerCase();

    if (search == "") {
      setState(() {
        filteredApps = apps.values.toList();
        filteredApps.sort((s1, s2) => s1.appName.compareTo(s2.appName));
      });
      return;
    }

    List<String> appnames = apps.keys.toList();

    for (int i = 0; i < 5; i++) {
      if (appnames.length <= 0) {
        break;
      }
      BestMatch match = StringSimilarity.findBestMatch(search, appnames);
      String key = appnames.removeAt(match.bestMatchIndex);
      filteredApps.add(apps[key]);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    return Material(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: "searchInput",
                child: InputField(
                  title: "Search",
                  controller: searchController,
                  onChanged: (input) {
                    search();
                  },
                  autoFocus: true,
                ),
              ),
              FutureBuilder(
                future: getApps(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      !snapshot.hasData ||
                      snapshot.data != true ||
                      filteredApps == null) {
                    return Container();
                  }

                  return Wrap(
                    runAlignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: filteredApps
                        .map(
                          (app) => buildSingleApp(
                            app: app,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
