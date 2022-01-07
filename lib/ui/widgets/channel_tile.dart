import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';

class ChannelTile extends StatelessWidget {
  final Channel channel;
  const ChannelTile({Key? key, required this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var lastCheck = DateTime.fromMillisecondsSinceEpoch(
        channel.status?.lastCheck ?? DateTime.now().millisecondsSinceEpoch);
    return Slidable(
        key: Key(channel.link),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
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
          subtitle: Text("last check:${timeago.format(lastCheck)}"),
          trailing: channel.status == null
              ? const SizedBox.shrink()
              : Text(
                  '${channel.status?.unreadCount}/${channel.status?.totalCount}'),
          onTap: () {
            context
                .read<ArticleBloc>()
                .add(ArticleRequested(channelLink: channel.link));
            Navigator.of(context)
                .pushNamed(AppRouter.articleScreen, arguments: channel);
          },
        )));
  }
}
