import 'package:flutter/material.dart';
import 'package:thelauncher/models/Article.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/newsService.dart';
import 'package:get/get.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Widget buildSingleArticle({Article article}) {
    double width = Get.width - 30;
    double height = width / 1.5;
    return NeumorphicButton(
      width: width,
      height: height,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          NeumorphicContainer(
            style: Style.emboss,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder<List<Article>>(
        future: locator<NewsService>()
            .fetchArticlesBySection(section: "technology"),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }

          return ListView(
              children: snapshot.data
                  .map((article) => buildSingleArticle(article: article))
                  .toList());
        },
      ),
    );
  }
}
