class ArticleStatus {
  int read;
  int starred;
  String articleId;
  ArticleStatus({
    required this.articleId,
    required this.read,
    required this.starred,
  });

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'read': read,
      'starred': starred,
    };
  }

  ArticleStatus.fromMap(Map<String, dynamic> data)
      : read = data['read'],
        articleId = data['articleId'],
        starred = data['starred'];
}
