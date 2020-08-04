import 'package:launcher_helper/launcher_helper.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  final storage = GetStorage();
  List<Application> apps;

  Future initializeStorage() async {
    ApplicationCollection _apps = await LauncherHelper.getApplications();
    apps = _apps.toList();

    var appMap = storage.read("appMap") ?? {};

    apps.forEach(
      (app) {
        appMap[app.packageName] = appMap[app.packageName] ?? 0;
      },
    );

    storage.write("appMap", appMap);
  }

  List<String> getMostUsedApps({int amount = 8}) {
    var appMap = storage.read("appMap") ?? {};

    List<String> sortedKeys = appMap.keys.toList(growable: false);

    sortedKeys.sort((k1, k2) {
      return appMap[k1].compareTo(
        appMap[k2],
      );
    });

    return sortedKeys.reversed.toList().take(amount).toList();
  }

  Application getApp({String packageName}) {
    return apps.firstWhere(
      (app) => app.packageName == packageName,
      orElse: () => null,
    );
  }

  List<String> getApps() {
    return apps.map<String>((app) => app.packageName).toList();
  }

  String getPackageName({String appName}) {
    Application app =
        apps.firstWhere((a) => a.label == appName, orElse: () => null);
    if (app != null) {
      return app.packageName;
    }
    return null;
  }

  List<String> getAppNames() {
    return apps.map<String>((app) => app.label).toList();
  }

  void increaseAppUsage({String packageName}) {
    var appMap = storage.read("appMap") ?? {};
    if (appMap.containsKey(packageName)) {
      appMap[packageName] = appMap[packageName] + 1;
    } else {
      appMap[packageName] = 1;
    }

    storage.write("appMap", appMap);
  }
}
