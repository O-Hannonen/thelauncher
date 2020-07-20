import 'dart:math';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/inputField.dart';
import 'package:device_apps/device_apps.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/storageService.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> filteredApps;
  TextEditingController searchController;
  MediaQueryData mediaQuery;
  StorageService storage = locator<StorageService>();

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

  Widget buildSingleApp({String packageName}) {
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    double side = min((height / 4) - 30, (width / 2) - 30);
    if (packageName == null) {
      return Container(
        margin: const EdgeInsets.all(15.0),
        width: side,
        height: side,
      );
    }

    dynamic app = storage.getApp(
      packageName: packageName,
    );

    return GestureDetector(
      onTap: () async {
        await DeviceApps.openApp(packageName);
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

  void search({String search}) async {
    if (filteredApps == null) {
      filteredApps = [];
    }
    filteredApps.clear();

    search = search.toLowerCase();

    if (search == "") {
      setState(() {
        filteredApps = null;
      });
      return;
    }

    List<String> appnames = storage.getAppNames();

    for (int i = 0; i < 6; i++) {
      if (appnames.length <= 0) {
        break;
      }
      BestMatch match = StringSimilarity.findBestMatch(search, appnames);
      String key = appnames.removeAt(match.bestMatchIndex);

      filteredApps.add(storage.getPackageName(appName: key));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    if (filteredApps == null) {
      filteredApps = storage.getMostUsedApps(amount: 6);
    }

    return Material(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: "searchInput",
              child: InputField(
                title: "Search",
                controller: searchController,
                onChanged: (input) {
                  search(search: input);
                },
                autoFocus: true,
              ),
            ),
            Wrap(
              runAlignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: filteredApps
                  .map(
                    (package) => buildSingleApp(
                      packageName: package,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
