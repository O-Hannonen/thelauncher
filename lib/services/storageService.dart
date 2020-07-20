import 'package:device_apps/device_apps.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  final storage = GetStorage();
  List apps;

  Future initializeStorage() async {
    apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
    );

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

  dynamic getApp({String packageName}) {
    return apps.firstWhere((app) => app.packageName == packageName);
  }

  List<String> getApps() {
    return apps.map<String>((app) => app.packageName).toList();
  }

  String getPackageName({String appName}) {
    dynamic app = apps.firstWhere((a) => a.appName == appName);
    if (app != null) {
      return app.packageName;
    }
    return null;
  }

  List<String> getAppNames() {
    return apps.map<String>((app) => app.appName).toList();
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
