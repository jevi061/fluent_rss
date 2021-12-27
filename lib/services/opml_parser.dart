import 'dart:convert';
import 'dart:io';

import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:opmlparser/opmlparser.dart';
import 'package:path/path.dart' as path;

class OPMLParser {
  Future<List<Channel>> parseURL(String path) async {
    var content = await File(path).readAsBytes();
    return parse(utf8.decode(content));
  }

  List<Channel> parse(String xml) {
    Opml opml = Opml.parse(xml);
    List<Channel> channels = [];
    opml.items?.forEach((e) {
      if (e.nesteditems?.isEmpty ?? true) {
        channels.add(Channel(
            title: e.title ?? "",
            link: e.xmlUrl ?? "",
            description: e.description ?? "",
            type: e.type ?? "",
            version: e.version ?? "",
            iconUrl: path.join(e.htmlUrl ?? '', FeedConstants.iconName),
            lastCheck: DateTime.now().millisecondsSinceEpoch,
            directory: '',
            unreadCount: 0,
            totalCount: 0));
      } else {
        e.nesteditems?.forEach((nested) {
          channels.add(Channel(
              title: nested.title ?? "",
              link: nested.xmlUrl ?? "",
              description: nested.description ?? "",
              type: nested.type ?? "",
              version: nested.version ?? "",
              iconUrl: path.join(nested.htmlUrl ?? '', FeedConstants.iconName),
              lastCheck: DateTime.now().millisecondsSinceEpoch,
              directory: e.title ?? "",
              unreadCount: 0,
              totalCount: 0));
        });
      }
    });

    return channels;
  }
}
