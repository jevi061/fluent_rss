import 'dart:convert';
import 'dart:io';

import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/domains/channel_group.dart';
import 'package:opmlparser/opmlparser.dart';
import 'package:path/path.dart' as path;

// parse opml file for channel or channel group
class OPMLParser {
  Future<List<Object>> parseURL(String path) async {
    var content = await File(path).readAsBytes();
    return parse(utf8.decode(content));
  }

// here Object represents Channel|ChannelGroup
  List<Object> parse(String xml) {
    Opml opml = Opml.parse(xml);
    List<Object> channels = [];
    opml.items?.forEach((e) {
      if (e.nesteditems?.isEmpty ?? true) {
        channels.add(Channel(
          title: e.title ?? "",
          link: e.xmlUrl ?? "",
          description: e.description ?? "",
          type: e.type ?? "",
          version: e.version ?? "",
          iconUrl: path.join(e.htmlUrl ?? '', FeedConstants.iconName),
          categoryId: 1,
        ));
      } else {
        Category category = Category(name: e.title ?? "");
        List<Channel> categorizedChannels = [];
        e.nesteditems?.forEach((nested) {
          categorizedChannels.add(Channel(
            title: nested.title ?? "",
            link: nested.xmlUrl ?? "",
            description: nested.description ?? "",
            type: nested.type ?? "",
            version: nested.version ?? "",
            iconUrl: path.join(nested.htmlUrl ?? '', FeedConstants.iconName),
          ));
        });
        channels.add(
            ChannelGroup(category: category, channels: categorizedChannels));
      }
    });

    return channels;
  }
}
