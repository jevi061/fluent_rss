import 'package:fluent_rss/business/blocs/feed/feed_bloc.dart';
import 'package:fluent_rss/business/blocs/feed/feed_state.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayArticlePage extends StatelessWidget {
  const TodayArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return Scrollbar(
          controller: ScrollController(),
          child: ListView.builder(
              itemCount: state.today.length,
              itemBuilder: (context, index) => ArticleTile(
                    article: state.today[index],
                  )));
    });
  }
}
