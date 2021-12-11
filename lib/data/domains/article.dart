import 'article_status.dart';

class Article {
  String uuid;
  // channel link
  String channel;
  String link;
  String title;
  int published;
  String subtitle;
  int read;
  int starred;
  Article(
      {required this.uuid,
      required this.channel,
      required this.title,
      required this.link,
      required this.published,
      required this.subtitle,
      required this.read,
      required this.starred});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'link': link,
      'channel': channel,
      'title': title,
      'subtitle': subtitle,
      'published': published,
      'starred': starred,
      'read': read
    };
  }

  Article.fromMap(Map<String, dynamic> data)
      : uuid = data['uuid'],
        channel = data['channel'],
        title = data['title'],
        link = data['link'],
        subtitle = data['subtitle'],
        published = data['published'],
        starred = data['starred'],
        read = data['read'];
}
