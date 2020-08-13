import 'package:flutter/material.dart';
import 'package:thelauncher/models/Article.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/reusableWidgets/neumorphicContainer.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/newsService.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Widget buildSingleArticle({Article article}) {
    double width = Get.width - 30;
    double height = width * 0.45;
    return NeumorphicButton(
      onTap: () async {
        if (await canLaunch(article.newsUrl)) {
          await launch(article.newsUrl);
        } else {
          print("Could not launch ${article.newsUrl}");
        }
      },
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NeumorphicContainer(
            width: height - 30,
            height: height - 30,
            style: Style.emboss,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: height - 50,
                height: height - 50,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: article.images.length != 0 &&
                          article.images.first != null
                      ? Container(
                          child: CachedNetworkImage(
                            imageUrl: article.images.first,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: Container(
                                  width: height - 50,
                                  height: height - 50,
                                  margin: EdgeInsets.all((height - 50) * 0.6),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      article.title ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    width: double.infinity,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      article.absctract ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        future: locator<NewsService>().fetchTopArticlesToday(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                width: Get.width * 0.15,
                height: Get.width * 0.15,
                child: CircularProgressIndicator(),
              ),
            );
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
