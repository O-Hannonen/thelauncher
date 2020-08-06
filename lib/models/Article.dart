class Article {
  final String section;
  final String title;
  final String absctract;
  final String newsUrl;
  final List<String> images;

  Article.fromMap({Map map})
      : this.section = map["section"],
        this.title = map["title"],
        this.absctract = map["abstract"],
        this.newsUrl = map["uri"],
        this.images = map["multimedia"].map((media) => media["url"]).toList();
}
