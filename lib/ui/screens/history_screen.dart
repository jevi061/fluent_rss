import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/bloc/history_bloc.dart';
import 'package:fluent_rss/business/state/article_state.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/business/state/history_state.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
        builder: (BuildContext context, HistoryState state) {
      return Scaffold(
          appBar: AppBar(title: Text("History")),
          body: ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) => ArticleTile(
                    article: state.articles[index],
                  )));
    });
  }
}
