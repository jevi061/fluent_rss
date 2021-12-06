import 'package:fluent_rss/business/bloc/app_bloc.dart';
import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelTile extends StatefulWidget {
  Channel channel;
  ChannelTile({Key? key, required this.channel}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<ChannelTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.channel.icon),
      ),
      title: Text("${widget.channel.title}"),
      onTap: () {
        context
            .read<ArticleBloc>()
            .add(ArticleRequested(channel: widget.channel));
        Navigator.of(context).pushNamed('/articles');
      },
    ));
  }
}
