import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ExportSnacker extends StatelessWidget {
  String path;
  ExportSnacker(this.path);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("export opml finished"),
        TextButton(
            onPressed: () async {
              await Share.shareFiles(
                [path + "/fluent_rss.opml"],
                subject: path + "/fluent_rss.opml",
              );
            },
            child: const Text("share"))
      ],
    );
  }
}
