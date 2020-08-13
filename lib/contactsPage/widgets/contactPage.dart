import 'package:string_similarity/string_similarity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thelauncher/reusableWidgets/inputField.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/storageService.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  PageController controller;
  FocusNode searchNode;
  TextEditingController searchController;
  List<Contact> results;
  StorageService storage = locator<StorageService>();

  @override
  void initState() {
    results = List<Contact>();
    searchNode = FocusNode();
    searchController = TextEditingController();
    controller = PageController(initialPage: 1);
    controller.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    searchController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (controller.offset >= Get.height + 100) {
      controller.animateToPage(
        controller.initialPage,
        duration: Duration(milliseconds: 150),
        curve: Curves.linear,
      );
      searchNode.unfocus();

      setState(() {
        searchNode = FocusNode();
      });
      searchNode.requestFocus();
    } else if (controller.offset <= Get.height - 100) {
      Get.focusScope.unfocus();
      Get.back();
    }
  }

  void search({String input}) {
    if (input == "") {
      results.clear();
      return;
    }

    results.clear();

    input = input.toLowerCase();

    List<String> contactNames = storage.getContactNames();

    for (int i = 0; i < 3; i++) {
      if (contactNames.length <= 0) {
        break;
      }
      BestMatch match = StringSimilarity.findBestMatch(input, contactNames);
      String key = contactNames.removeAt(match.bestMatchIndex);

      results.add(storage.getContactByName(name: key));
    }

    setState(() {});
  }

  Widget buildSingleContact({Contact contact}) {
    return Flexible(
      flex: 1,
      child: NeumorphicContainer(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NeumorphicContainer(
              style: Style.emboss,
              shape: BoxShape.circle,
              bevel: 20.0,
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(10.0),
              width: (Get.width - 30) * 0.3,
              height: (Get.width - 30) * 0.3,
              child: Container(
                width: (Get.width - 30) * 0.3,
                height: (Get.width - 30) * 0.3,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${contact.displayName[0]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${contact.displayName}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${contact.phones != null && contact.phones.length != 0 ? contact.phones.first.value : "-"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            NeumorphicButton(
              width: (Get.width - 30) * 0.15,
              height: (Get.width - 30) * 0.15,
              shape: BoxShape.circle,
              onTap: () {
                storage.increaseContactPopularity(
                  identifier: contact.identifier,
                );
                if (contact.phones != null && contact.phones.length != 0) {
                  final phoneNumber = contact.phones.first.value;
                  launch("tel://$phoneNumber");
                }
              },
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(15.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.call_end,
                  color: Theme.of(context).primaryColor,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (results.length == 0) {
      results.addAll(storage.getMostUsedContacts(amount: 3));
    }
    return Material(
      color: Theme.of(context).backgroundColor,
      child: PageView(
        scrollDirection: Axis.vertical,
        controller: controller,
        children: [
          Container(),
          Scaffold(
            resizeToAvoidBottomInset: true,
            resizeToAvoidBottomPadding: true,
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  ...results
                      .map((contact) => buildSingleContact(contact: contact))
                      .toList(),
                  InputField(
                    controller: searchController,
                    title: "Search",
                    focusNode: searchNode,
                    onChanged: (input) {
                      search(input: input);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
