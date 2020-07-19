import 'package:flutter/material.dart';
import 'package:thelauncher/body.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.blueGrey[800],
      ),
      builder: (context, child) {
        return Body();
      },
    ),
  );
}
