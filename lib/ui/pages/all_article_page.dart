import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_event.dart';
import 'package:fluent_rss/business/blocs/article/article_state.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_bloc.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_event.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_state.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllArticlePage extends StatefulWidget {
  const AllArticlePage({Key? key}) : super(key: key);

  @override
  State<AllArticlePage> createState() => _AllArticlePageState();
}

class _AllArticlePageState extends State<AllArticlePage> {
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
    if (_isBottom()) {
      context.read<AllFeedBloc>().add(AllFeedLoadTriggered());
    }
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
      listenWhen: (previous, current) => current is ArticleStatusChangedState,
      listener: (context, state) {
        if (state is ArticleStatusChangedState) {
          BlocProvider.of<AllFeedBloc>(context).add(AllFeedOutdated());
        }
      },
      child: BlocBuilder<AllFeedBloc, AllFeedState>(builder: (context, state) {
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
