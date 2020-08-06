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
        this.newsUrl = map["url"],
        this.images = map["media"] != null
            ? List<String>.from(map["media"]
                .map((media) => media["media-metadata"] != null
                    ? media["media-metadata"].last["url"]
                    : null)
                .toList())
            : List<String>();
}
