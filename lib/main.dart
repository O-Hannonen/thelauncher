import 'package:flutter/material.dart';
import 'package:thelauncher/body.dart';
import 'package:get/get.dart';

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.blueGrey[800],
        primaryColor: Colors.orange[800],
      ),
      home: Body(),
    ),
  );
}
