import 'package:get_it/get_it.dart';
import 'package:thelauncher/services/storageService.dart';

GetIt locator = GetIt.instance;

Future setupServiceLocator() async {
  locator.registerSingletonAsync(
    () async {
      StorageService storage = StorageService();
      await storage.initializeStorage();

      return storage;
    },
  );
}