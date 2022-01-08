import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelSearcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          var channelRepository =
              RepositoryProvider.of<ChannelRepository>(context);
          showSearch(
              context: context,
              delegate: ChannelSearchDelegate(channelRepository));
        },
        icon: const Icon(Icons.search));
  }
}
