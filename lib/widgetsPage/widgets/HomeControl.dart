import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:get/get.dart';
import 'package:thelauncher/services/homeControlService.dart';
import 'package:thelauncher/services/service_locator.dart';

class HomeControl extends StatefulWidget {
  HomeControl({Key key}) : super(key: key);

  @override
  _HomeControlState createState() => _HomeControlState();
}

class _HomeControlState extends State<HomeControl> {
  HomeControlService homeControl = locator<HomeControlService>();

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      width: Get.width - 30,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Home Control",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                width: (Get.width - 100) * 0.35,
                height: (Get.width - 100) * 0.35,
                style: Style.convex,
                bevel: 10.0,
                shape: BoxShape.circle,
                onTap: () async {
                  await homeControl.triggerWebHooks(
                    function: HomeControlService.lightsOff,
                  );
                },
                margin: const EdgeInsets.all(15.0),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 35.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              NeumorphicButton(
                width: (Get.width - 100) * 0.35,
                height: (Get.width - 100) * 0.35,
                style: Style.convex,
                bevel: 10.0,
                shape: BoxShape.circle,
                onTap: () async {
                  await homeControl.triggerWebHooks(
                    function: HomeControlService.lightsOn,
                  );
                },
                margin: const EdgeInsets.all(15.0),
                child: Icon(
                  Icons.lightbulb,
                  size: 35.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                width: (Get.width - 100) * 0.35,
                height: (Get.width - 100) * 0.35,
                style: Style.convex,
                bevel: 10.0,
                shape: BoxShape.circle,
                onTap: () async {
                  await homeControl.triggerWebHooks(
                    function: HomeControlService.movieLights,
                  );
                },
                margin: const EdgeInsets.all(15.0),
                child: Icon(
                  Icons.brightness_2_outlined,
                  size: 35.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              NeumorphicButton(
                width: (Get.width - 100) * 0.35,
                height: (Get.width - 100) * 0.35,
                style: Style.convex,
                bevel: 10.0,
                shape: BoxShape.circle,
                onTap: () async {
                  await homeControl.triggerWebHooks(
                    function: HomeControlService.normalLights,
                  );
                },
                margin: const EdgeInsets.all(15.0),
                child: Icon(
                  Icons.brightness_high,
                  size: 35.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
