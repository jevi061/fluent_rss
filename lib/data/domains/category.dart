import 'article_status.dart';

class Category {
  int? id;
  String name;
  Category({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  Category.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'];
}
