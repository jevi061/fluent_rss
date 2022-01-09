import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'channel_delegate.dart';

class CategorySearchbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: TextField(
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "Search channels",
          border: OutlineInputBorder(),
        ),
        onTap: () {
          var channelRepository =
              RepositoryProvider.of<ChannelRepository>(context);
          showSearch(
              context: context,
              delegate: ChannelSearchDelegate(channelRepository));
        },
      ),
    );
  }
}
