class Channel {
  // channel link as primary key to avoid duplicate insert operation.
  String link;
  String title;
  String description;
  String type;
  String version;
  String icon;
  Channel(
      {required this.title,
      required this.link,
      required this.description,
      required this.type,
      required this.version,
      required this.icon});
  Map<String, dynamic> toMap() {
    return {
      'link': link,
      'title': title,
      'description': description,
      'type': type,
      'version': version,
      'icon': icon
    };
  }

  Channel.fromMap(Map<String, dynamic> data)
      : title = data['title'] ?? "",
        link = data['link'],
        description = data['description'] ?? "",
        type = data['type'] ?? "",
        version = data['version'] ?? "",
        icon = data['icon'] ?? "";
}
