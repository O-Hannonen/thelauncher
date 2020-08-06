import 'dart:math';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/inputField.dart';
import 'package:launcher_helper/launcher_helper.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:thelauncher/services/calculatorService.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/storageService.dart';
import 'package:get/get.dart';
import '../../main.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> filteredApps;
  TextEditingController searchController;
  MediaQueryData mediaQuery;
  FocusNode searchNode;
  StorageService storage = locator<StorageService>();
  CalculatorService calculator = locator<CalculatorService>();
  num calculationResult;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    searchNode = FocusNode();
    searchController = TextEditingController();
    pageController = PageController(initialPage: 1);
    pageController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (pageController.offset < mediaQuery.size.height - 50) {
      pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 150),
        curve: Curves.ease,
      );
      Get.focusScope.unfocus();
      Get.focusScope.requestFocus(searchNode);
    } else if (pageController.offset >=
        mediaQuery.size.height +
            mediaQuery.viewPadding.top +
            mediaQuery.size.width * 0.15 +
            30) {
      FocusScope.of(context).unfocus();
      Get.back();
    } else if (pageController.offset > mediaQuery.size.height + 50) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget buildSingleApp({String packageName}) {
    double width = mediaQuery.size.width - 30;

    if (packageName == null) {
      return Flexible(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.all(15.0),
          width: width - 30,
        ),
      );
    }

    Application app = storage.getApp(
      packageName: packageName,
    );

    return Flexible(
      flex: 1,
      child: NeumorphicButton(
        onTap: () async {
          storage.increaseAppUsage(
            packageName: packageName,
          );
          Get.focusScope.unfocus();
          Get.back();
          await LauncherHelper.launchApp(packageName);
        },
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(15.0),
        width: width - 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: NeumorphicContainer(
                width: width * 0.3,
                height: width * 0.3,
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
      ),
    );
  }

  void search({String search}) async {
    dynamic result = calculator.calculate(input: search);
    if (result != null) {
      calculationResult = num.parse("$result");
    } else {
      calculationResult = null;
    }
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

    for (int i = 0; i < (calculationResult == null ? 3 : 2); i++) {
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
      filteredApps = List<String>();
    }

    return PageView(
      scrollDirection: Axis.vertical,
      controller: pageController,
      children: [
        Material(
          color: Theme.of(context).backgroundColor,
        ),
        Scaffold(
          resizeToAvoidBottomPadding: true,
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: mediaQuery.size.height -
                    mediaQuery.viewPadding.top -
                    mediaQuery.viewPadding.bottom -
                    mediaQuery.viewInsets.top -
                    mediaQuery.viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Hero(
                    tag: "searchInput",
                    child: InputField(
                      title: "Search",
                      focusNode: searchNode,
                      controller: searchController,
                      onChanged: (input) {
                        search(search: input);
                      },
                      autoFocus: true,
                    ),
                  ),
                  if (calculationResult != null)
                    Flexible(
                      flex: 1,
                      child: NeumorphicContainer(
                        width: Get.width - 60,
                        margin: const EdgeInsets.all(15.0),
                        child: Text(
                          "=${calculationResult.toString().length > 10 ? calculationResult.toString().substring(0, 11) + "..." : calculationResult}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ...filteredApps
                      .map(
                        (package) => buildSingleApp(
                          packageName: package,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: Theme.of(context).backgroundColor,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(15.0),
              height: Get.width * 0.15,
              width: Get.width * 0.15,
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
