import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/read/reading_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_event.dart';
import 'package:fluent_rss/business/blocs/read/reading_event.dart';
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
    return Container(
      child: InkWell(
        onTap: () {
          context.read<ArticleBloc>().add(ArticleRead(
              article: article, previousRead: article.status?.read ?? 0));
          context.read<ReadingBloc>().add(ReadingStarted(article: article));
          Navigator.of(context).pushNamed(AppRouter.readScreen);
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                        maxLines: 2,
                      ),
                    ],
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      IconButton(
                        icon: article.status?.starred == 0
                            ? const Icon(
                                Icons.star_outline,
                              )
                            : const Icon(Icons.star),
                        onPressed: () {
                          var currentStar =
                              article.status?.starred == 0 ? 1 : 0;
                          context.read<ArticleBloc>().add(ArticleStarTriggered(
                              article: article, currentStar: currentStar));
                        },
                      )
                    ],
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
                    size: 10,
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
