import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/providers/category_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';

class CategoryRepository {
  CategoryProvider categoryProvider;
  ChannelProvider channelProvider;
  CategoryRepository(
      {required this.categoryProvider, required this.channelProvider});

  Future<void> deleteCategory(int id) async {
    await categoryProvider.deleteCategory(id);
  }

  Future<int?> addCategory(Category category) async {
    return await categoryProvider.insert(category);
  }

  Future<List<Category>> getCategories() async {
    return await categoryProvider.queryAll();
  }
}
