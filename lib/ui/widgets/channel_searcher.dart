import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChannelSearcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(context: context, delegate: ChannelSearchDelegate([]));
        },
        icon: const Icon(Icons.search));
  }
}
