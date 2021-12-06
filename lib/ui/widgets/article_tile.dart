import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/bloc/favorite_bloc.dart';
import 'package:fluent_rss/business/bloc/history_bloc.dart';
import 'package:fluent_rss/business/bloc/reading_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/favorite_event.dart';
import 'package:fluent_rss/business/event/history_event.dart';
import 'package:fluent_rss/business/event/reading_event.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ArticleTile extends StatelessWidget {
  Article article;
  ArticleTile({required this.article});
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(article.published);
    var formattedDate = DateFormat.yMMMd().format(date);
    return Card(
      child: InkWell(
        onTap: () {
          context.read<ReadingBloc>().add(ReadingStarted(article: article));
          context.read<HistoryBloc>().add(HistoryUpdated(article: article));
          Navigator.of(context).pushNamed('/reading');
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formattedDate),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.bookmark),
                    onPressed: () {
                      context
                          .read<FavoriteBloc>()
                          .add(FavoriteUpdated(article: article));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
