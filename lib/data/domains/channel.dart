import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel_status.dart';

class Channel {
  // channel link as primary key to avoid duplicate insert operation.
  String link;
  String title;
  String description;
  String type;
  String version;
  String iconUrl;
  int categoryId;
  ChannelStatus? status;
  Channel({
    required this.title,
    required this.link,
    required this.description,
    required this.type,
    required this.version,
    required this.iconUrl,
    required this.categoryId,
    this.status,
  });
  Map<String, dynamic> toMap() {
    return {
      'link': link,
      'title': title,
      'description': description,
      'type': type,
      'version': version,
      'iconUrl': iconUrl,
      'categoryId': categoryId,
    };
  }

  Channel.fromMap(Map<String, dynamic> data)
      : title = data['title'] ?? "",
        link = data['link'],
        description = data['description'] ?? "",
        type = data['type'] ?? "",
        version = data['version'] ?? "",
        categoryId = data["categoryId"],
        iconUrl = data['iconUrl'] ?? "";
}
