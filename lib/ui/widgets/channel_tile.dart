import 'package:fluent_rss/business/bloc/app_bloc.dart';
import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChannelTile extends StatelessWidget {
  Channel channel;
  ChannelTile({Key? key, required this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var lastCheck = DateTime.fromMillisecondsSinceEpoch(channel.lastCheck);
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(channel.iconUrl),
      ),
      title: Text(channel.title),
      subtitle: Text("last check:${timeago.format(lastCheck)}"),
      onTap: () {
        context.read<ArticleBloc>().add(ArticleRequested(channel: channel));
        Navigator.of(context).pushNamed('/articles');
      },
    ));
  }
}
