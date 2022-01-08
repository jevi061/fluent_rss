import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_state.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_bloc.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_state.dart';
import 'package:fluent_rss/business/blocs/feed/today_feed_bloc.dart';
import 'package:fluent_rss/business/blocs/feed/today_feed_event.dart';
import 'package:fluent_rss/business/blocs/feed/today_feed_state.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayArticlePage extends StatefulWidget {
  const TodayArticlePage({Key? key}) : super(key: key);

  @override
  State<TodayArticlePage> createState() => _TodayArticlePageState();
}

class _TodayArticlePageState extends State<TodayArticlePage> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    context.read<TodayFeedBloc>().add(TodayFeedLoadTriggered());
  }

  bool _isBottom() {
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {},
      child:
          BlocBuilder<TodayFeedBloc, TodayFeedState>(builder: (context, state) {
        return Scrollbar(
            controller: ScrollController(),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: state.articles.length,
                itemBuilder: (context, index) => ArticleTile(
                      article: state.articles[index],
                    )));
      }),
    );
  }
}
