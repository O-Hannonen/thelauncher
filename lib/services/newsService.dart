import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thelauncher/models/Article.dart';

class NewsService {
  static const String API_KEY = "oUMZC9Wn9sS2kJedVB3R12y0PMjVNpmm";
  final String _baseUrl = "api.nytimes.com";

  Future<List<Article>> fetchArticlesBySection({String section}) async {
    Map<String, String> parameters = {
      'api-key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/svc/topstories/v2/$section.json',
      parameters,
    );

    try {
      var response = await http.get(uri);
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
