import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_state.dart';
import 'package:fluent_rss/business/blocs/favorite/favorite_bloc.dart';
import 'package:fluent_rss/business/blocs/favorite/favorite_event.dart';
import 'package:fluent_rss/business/blocs/favorite/favorite_state.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listenWhen: (previous, current) => current is ArticleStatusChangedState,
      listener: (context, state) {
        if (state is ArticleStatusChangedState) {
          BlocProvider.of<FavoriteBloc>(context).add(FavoriteOutdated());
        }
      },
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (BuildContext context, FavoriteState state) {
        return Scaffold(
            appBar: AppBar(title: const Text("Favorites")),
            body: ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) => ArticleTile(
                      article: state.articles[index],
                    )));
      }),
    );
  }
}
