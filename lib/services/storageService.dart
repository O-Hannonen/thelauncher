import 'package:launcher_helper/launcher_helper.dart';
import 'package:get_storage/get_storage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  final storage = GetStorage();
  List<Application> apps;
  ApplicationCollection applicationCollection;
  List<Contact> userContacts;

  Future initializeContacts() async {
    bool hasPermission = await Permission.contacts.request().isGranted;
    if (!hasPermission) {
      return;
    }
    Iterable<Contact> contacts = await ContactsService.getContacts();

    var contactsMap = storage.read("contactsMap") ?? {};

    contacts.forEach(
      (contact) {
        contactsMap[contact.identifier] = contactsMap[contact.identifier] ?? 0;
      },
    );

    storage.write("contactsMap", contactsMap);

    userContacts = contacts.toList();
  }

  Future initializeApps() async {
    applicationCollection = await LauncherHelper.getApplications();
    apps = applicationCollection.toList();

    var appMap = storage.read("appMap") ?? {};

    apps.forEach(
      (app) {
        appMap[app.packageName] = appMap[app.packageName] ?? 0;
      },
    );

    storage.write("appMap", appMap);
  }

  Future initializeStorage() async {
    await initializeApps();
    await initializeContacts();
  }

  Future refreshApps() async {
    applicationCollection =
        await LauncherHelper.updateApplicationCollection(applicationCollection);

    apps = applicationCollection.toList();

    var appMap = storage.read("appMap") ?? {};

    apps.forEach(
      (app) {
        appMap[app.packageName] = appMap[app.packageName] ?? 0;
      },
    );

    storage.write("appMap", appMap);
  }

  List<Contact> getMostUsedContacts({int amount = 3}) {
    var contactsMap = storage.read("contactsMap") ?? {};

    List<String> sortedKeys = contactsMap.keys.toList(growable: false);

    sortedKeys.sort((k1, k2) {
      return contactsMap[k1].compareTo(
        contactsMap[k2],
      );
    });
    sortedKeys = sortedKeys.reversed.toList().take(amount).toList();

    List<Contact> output = List<Contact>();

    sortedKeys.forEach((identifier) {
      Contact contact = userContacts.firstWhere(
        (c) => c.identifier == identifier,
        orElse: () => null,
      );

      if (contact != null) {
        output.add(contact);
      }
    });

    return output;
  }

  Contact getContactByName({String name}) {
    return userContacts.firstWhere(
      (c) => c.displayName == name,
      orElse: () => null,
    );
  }

  List<String> getContactNames() {
    return List<String>.from(userContacts.map((c) => c.displayName).toList());
  }

  List<String> getMostUsedApps({int amount = 8}) {
    var appMap = storage.read("appMap") ?? {};

    List<String> sortedKeys = appMap.keys.toList(growable: false);

    sortedKeys.sort((k1, k2) {
      return appMap[k1].compareTo(
        appMap[k2],
      );
    });
    List<String> output = List<String>();

    for (String s in sortedKeys.reversed) {
      if (output.length >= amount) {
        break;
      }

      if (getApp(packageName: s) != null) {
        output.add(s);
      }
    }

    return output;
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

  void increaseContactPopularity({String identifier}) {
    var contactsMap = storage.read("contactsMap") ?? {};
    if (contactsMap.containsKey(identifier)) {
      contactsMap[identifier] = contactsMap[identifier] + 1;
    } else {
      contactsMap[identifier] = 1;
    }

    storage.write("contactsMap", contactsMap);
  }
}
