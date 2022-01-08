import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_state.dart';
import 'package:fluent_rss/business/blocs/history/history_bloc.dart';
import 'package:fluent_rss/business/blocs/history/history_event.dart';
import 'package:fluent_rss/business/blocs/history/history_state.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listenWhen: (previous, current) => current is ArticleStatusChangedState,
      listener: (context, state) {
        if (state is ArticleStatusChangedState) {
          BlocProvider.of<HistoryBloc>(context).add(HistoryOutdated());
        }
      },
      child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (BuildContext context, HistoryState state) {
        return Scaffold(
            appBar: AppBar(title: Text("History")),
            body: ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) => ArticleTile(
                      article: state.articles[index],
                    )));
      }),
    );
  }
}
