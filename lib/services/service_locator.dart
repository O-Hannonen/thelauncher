import 'package:get_it/get_it.dart';
import 'package:thelauncher/services/schoolLunchService.dart';
import 'package:thelauncher/services/storageService.dart';
import 'package:thelauncher/services/weatherService.dart';

import 'calculatorService.dart';
import 'covidDataService.dart';
import 'newsService.dart';

GetIt locator = GetIt.instance;

Future setupServiceLocator() async {
  locator.registerSingletonAsync(
    () async {
      StorageService storage = StorageService();
      await storage.initializeStorage();

      return storage;
    },
  );
  locator.registerSingleton(CalculatorService());
  locator.registerSingleton(NewsService());
  locator.registerSingleton(CovidDataService());
  locator.registerSingleton(SchoolLunchService());
  locator.registerSingleton(WeatherService());
}
