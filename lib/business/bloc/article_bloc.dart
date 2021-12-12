import 'dart:async';

import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/state/article_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleRepository articleRepository;
  ArticleBloc({required this.articleRepository})
      : super(ArticleState.ready(articles: [])) {
    on<ArticleStarted>(_onArticleStarted);
    on<ArticleRequested>(_onArticleRequested);
    on<ArticleChannelUpdated>(_onArticleStarted);
    on<ArticleChannelRefreshed>(_onArticleChannelRefreshed);
    on<ArticleStarred>(_onArticleStarred);
    on<ArticleRead>(_onArticleRead);
  }

  Future<void> _onArticleStarted(
      ArticleEvent event, Emitter<ArticleState> emitter) async {
    await articleRepository.syncArticles();

    // emitter(ArticleState.ready(channel: "", articles: []));
  }

  Future<void> _onArticleRequested(
      ArticleRequested event, Emitter<ArticleState> emitter) async {
    List<Article> articles =
        await articleRepository.queryByLink(event.channelLink);
    emitter(ArticleState.ready(articles: articles));
  }

  Future<void> _onArticleStarred(
      ArticleStarred event, Emitter<ArticleState> emitter) async {
    articleRepository.updateStarStatus(
        event.article.uuid, event.article.starred);
    List<Article> articles =
        await articleRepository.queryByLink(event.article.channel);
    emitter(ArticleState.ready(articles: articles));
  }

  Future<void> _onArticleChannelRefreshed(
      ArticleChannelRefreshed event, Emitter<ArticleState> emitter) async {
    await articleRepository.syncArticlesByChannel(event.channelLink);
    List<Article> articles =
        await articleRepository.queryByLink(event.channelLink);
    emitter(ArticleState.ready(articles: articles));
  }

  Future<void> _onArticleRead(
      ArticleRead event, Emitter<ArticleState> emitter) async {
    List<Article> articles =
        await articleRepository.queryByLink(event.article.channel);
    emitter(ArticleState.ready(articles: articles));
  }
}
