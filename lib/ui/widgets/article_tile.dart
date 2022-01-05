import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/favorite_bloc.dart';
import 'package:fluent_rss/business/bloc/feed_bloc.dart';
import 'package:fluent_rss/business/bloc/history_bloc.dart';
import 'package:fluent_rss/business/bloc/reading_bloc.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/favorite_event.dart';
import 'package:fluent_rss/business/event/feed_event.dart';
import 'package:fluent_rss/business/event/history_event.dart';
import 'package:fluent_rss/business/event/reading_event.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/router/app_router.dart';
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
          context.read<ArticleBloc>().add(ArticleRead(article));
          context.read<ReadingBloc>().add(ReadingStarted(article: article));
          context.read<HistoryBloc>().add(HistoryUpdated(article: article));
          context.read<FeedBloc>().add(FeedsStateChanged());
          Navigator.of(context).pushNamed(AppRouter.readScreen);
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
                  IconButton(
                    icon: article.status?.starred == 0
                        ? const Icon(
                            Icons.star_outline,
                          )
                        : const Icon(Icons.star),
                    onPressed: () {
                      article.status?.starred == 0
                          ? article.status?.starred = 1
                          : article.status?.starred = 0;
                      context.read<ArticleBloc>().add(ArticleStarred(article));
                      context
                          .read<FavoriteBloc>()
                          .add(FavoriteUpdated(article: article));
                      context
                          .read<HistoryBloc>()
                          .add(HistoryUpdated(article: article));
                      context.read<FeedBloc>().add(FeedsStateChanged());
                    },
                  )
                ],
              ),
            ),
            if (article.status?.read == 0) ...[
              const Positioned(
                  left: 10,
                  top: 16,
                  child: Icon(
                    Icons.circle,
                    color: Colors.blue,
                    size: 10,
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
