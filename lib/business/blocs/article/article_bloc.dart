import 'dart:async';

import 'package:fluent_rss/business/blocs/article/article_event.dart';
import 'package:fluent_rss/business/blocs/article/article_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ChannelRepository channelRepository;
  ArticleRepository articleRepository;
  ArticleBloc(
      {required this.channelRepository, required this.articleRepository})
      : super(ArticleState.ready(articles: [])) {
    on<ArticleStarted>(_onArticleStarted);
    on<ArticleRequested>(_onArticleRequested);
    on<ArticleChannelUpdated>(_onArticleStarted);
    // on<ArticleChannelRefreshStarted>(_onArticleChannelRefreshStarted);
    // on<ArticleChannelRefreshFinished>(_onArticleChannelRefreshFinished);
    on<ArticleStarred>(_onArticleStarred);
    on<ArticleRead>(_onArticleRead);
    on<ArticleStatusChanged>(_onArticleStatusChanged);
  }

  Future<void> _onArticleStarted(
      ArticleEvent event, Emitter<ArticleState> emitter) async {
    //await articleRepository.refreshAllArticles();
  }
  Future<void> _onArticleStatusChanged(
      ArticleStatusChanged event, Emitter<ArticleState> emitter) async {}

  Future<void> _onArticleRequested(
      ArticleRequested event, Emitter<ArticleState> emitter) async {
    List<Article> articles =
        await articleRepository.queryByLink(event.channelLink);
    emitter(ArticleState.ready(articles: articles));
  }

  Future<void> _onArticleStarred(
      ArticleStarred event, Emitter<ArticleState> emitter) async {
    await articleRepository.updateArticleStarStatus(
        event.article.uuid, event.article.status?.starred ?? 0);
    List<Article> articles =
        await articleRepository.queryByLink(event.article.channel);
    emitter(ArticleState.ready(articles: articles));
  }

  // Future<void> _onArticleChannelRefreshStarted(
  //     ArticleChannelRefreshStarted event, Emitter<ArticleState> emitter) async {
  //   await articleRepository.refreshArticles([event.channel]);
  //   add(ArticleChannelRefreshFinished(channel: event.channel));
  // }

  // Future<void> _onArticleChannelRefreshFinished(
  //     ArticleChannelRefreshFinished event,
  //     Emitter<ArticleState> emitter) async {
  //   List<Article> articles =
  //       await articleRepository.queryByLink(event.channel.link);
  //   emitter(ArticleState.ready(articles: articles));
  // }

  // Future<void> _onArticleChannelRefreshed(
  //     ArticleChannelRefreshed event, Emitter<ArticleState> emitter) async {
  //   await articleRepository.refreshArticles([event.channel]);
  //   List<Article> articles =
  //       await articleRepository.queryByLink(event.channel.link);
  //   emitter(ArticleState.ready(articles: articles));
  // }

  Future<void> _onArticleRead(
      ArticleRead event, Emitter<ArticleState> emitter) async {
    await articleRepository.updateArticleReadStatus(event.article.uuid, 1);
    await channelRepository.decreaseUnread(event.article.channel);
    List<Article> articles =
        await articleRepository.queryByLink(event.article.channel);
    emitter(ArticleState.ready(articles: articles));
  }
}
