import 'dart:io';

import 'package:fluent_rss/data/domains/channel.dart';
import 'package:logger/logger.dart';
import 'package:opmlparser/opmlparser.dart';
import 'package:path/path.dart' as path;

class OPMLParser {
  Future<List<Channel>> parseURL(String path) async {
    String content = await File(path).readAsString();
    return parse(content);
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
            icon: path.join(e.htmlUrl ?? '', 'favicon.ico')));
      } else {
        e.nesteditems?.forEach((nested) {
          channels.add(Channel(
              title: nested.title ?? "",
              link: nested.xmlUrl ?? "",
              description: nested.description ?? "",
              type: nested.type ?? "",
              version: nested.version ?? "",
              icon: path.join(nested.htmlUrl ?? '', 'favicon.ico')));
        });
      }
    });

    return channels;
  }
}
