import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTile extends StatelessWidget {
  Category category;
  CategoryTile({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key(category.id.toString()),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                // context.read<ChannelBloc>().add(ChannelDeleted(channel));
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
          title: Text(category.name),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pushNamed('/articles');
          },
        )));
  }
}