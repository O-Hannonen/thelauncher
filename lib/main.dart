import 'package:flutter/material.dart';
import 'package:thelauncher/body.dart';
import 'package:get/get.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:get_storage/get_storage.dart';

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

void main() async {
  await GetStorage.init();
  await setupServiceLocator();
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.blueGrey[800],
        primaryColor: Colors.orange[800],
      ),
      home: FutureBuilder(
        future: locator.allReady(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Material(
              color: Theme.of(context).backgroundColor,
            );
          }
          return Body();
        },
      ),
    ),
  );
}
