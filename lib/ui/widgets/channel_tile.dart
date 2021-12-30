import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';

class ChannelTile extends StatelessWidget {
  Channel channel;
  ChannelTile({Key? key, required this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var lastCheck =
        DateTime.fromMillisecondsSinceEpoch(channel.status?.lastCheck ?? 0);
    return Slidable(
        key: Key(channel.link),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                context.read<ChannelBloc>().add(ChannelDeleted(channel));
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'delete',
            ),
          ],
        ),
        child: Card(
            child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(channel.iconUrl),
          ),
          title: Text(channel.title),
          subtitle: Row(
            children: [
              Text('category'),
              Text("last check:${timeago.format(lastCheck)}")
            ],
          ),
          trailing: Text(
              '${channel.status?.unreadCount}/${channel.status?.totalCount}'),
          onTap: () {
            context
                .read<ArticleBloc>()
                .add(ArticleRequested(channelLink: channel.link));
            Navigator.of(context).pushNamed('/articles', arguments: channel);
          },
        )));
  }
}
