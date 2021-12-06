import 'package:fluent_rss/business/bloc/today_bloc.dart';
import 'package:fluent_rss/business/state/today_state.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayBloc, TodayState>(
        builder: (BuildContext context, TodayState state) {
      return Scaffold(
          appBar: AppBar(title: Text("Today")),
          body: ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) => ArticleTile(
                    article: state.articles[index],
                  )));
    });
  }
}
