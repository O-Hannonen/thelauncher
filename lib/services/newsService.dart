import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thelauncher/models/Article.dart';

class NewsService {
  static const String API_KEY = "oUMZC9Wn9sS2kJedVB3R12y0PMjVNpmm";

  Future<List<Article>> fetchTopArticlesToday() async {
    try {
      var response = await http.get(
        "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=$API_KEY",
      );

      Map<String, dynamic> data = json.decode(response.body);

      List<Article> articles = List<Article>();

      data["results"].forEach((result) {
        articles.add(Article.fromMap(map: result));
      });
      return articles;
    } catch (e) {
      print(e.toString());
    }

    return [];
  }
}
