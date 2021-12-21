import 'dart:io';

import 'package:fluent_rss/data/domains/channel.dart';
import 'package:opml/opml.dart';

class OPMLBuilder {
  static Future<String> buildOPML(List<Channel> channels) async {
    List<OpmlOutline> outlines = [];
    for (var ch in channels) {
      outlines.add(OpmlOutline(
        type: ch.type,
        title: ch.title,
        xmlUrl: ch.link,
        version: ch.version,
        description: ch.description,
      ));
    }
    final opml = OpmlDocument(
      head: OpmlHead(
        title: 'fluent_rss export',
      ),
      body: outlines,
    );
    return opml.toXmlString(pretty: true);
  }
}
