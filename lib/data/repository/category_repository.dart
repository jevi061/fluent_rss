import 'package:fluent_rss/data/domains/article.dart';
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

// get all categories and uncategorized channels
  Future<List<Object>> getAll() async {
    List<Object> all = [];
    var categories = await categoryProvider.queryAll();
    all.addAll(categories);
    var uncategorizedChannels = await channelProvider.queryByCategoryId(0);
    all.addAll(uncategorizedChannels);
    return all;
  }
}
