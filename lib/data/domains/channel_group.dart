import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class ChannelGroup {
  List<Channel> channels;
  Category category;
  ChannelGroup({required this.category, required this.channels});
}
