class Channel {
  // channel link as primary key to avoid duplicate insert operation.
  String link;
  String title;
  String description;
  String type;
  String version;
  String iconUrl;
  String directory;
  int lastCheck;
  int unreadCount;
  int totalCount;
  Channel(
      {required this.title,
      required this.link,
      required this.description,
      required this.type,
      required this.version,
      required this.iconUrl,
      required this.lastCheck,
      required this.directory,
      required this.unreadCount,
      required this.totalCount});
  Map<String, dynamic> toMap() {
    return {
      'link': link,
      'title': title,
      'description': description,
      'type': type,
      'version': version,
      'iconUrl': iconUrl,
      'lastCheck': lastCheck,
      'directory': directory,
      'unreadCount': unreadCount,
      'totalCount': totalCount
    };
  }

  Channel.fromMap(Map<String, dynamic> data)
      : title = data['title'] ?? "",
        link = data['link'],
        description = data['description'] ?? "",
        type = data['type'] ?? "",
        version = data['version'] ?? "",
        iconUrl = data['iconUrl'] ?? "",
        lastCheck = data['lastCheck'] ?? 0,
        directory = data['directory'],
        unreadCount = data['unreadCount'] ?? 0,
        totalCount = data['totalCount'] ?? 0;
}
