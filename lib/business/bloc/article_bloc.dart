import 'dart:async';
import 'dart:math';

import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/business/state/article_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'app_bloc.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleRepository articleRepository;
  ArticleBloc({required this.articleRepository})
      : super(ArticleState.ready(
            channel: Channel(
                title: "title",
                link: "link",
                description: "description",
                type: "type",
                version: "version",
                iconUrl: "iconUrl",
                lastCheck: 0,
                directory: "directory",
                unreadCount: 0,
                totalCount: 0),
            articles: [])) {
    on<ArticleStarted>(_onArticleStarted);
    on<ArticleRequested>(_onArticleRequested);
    on<ArticleChannelUpdated>(_onArticleStarted);
    on<ArticleChannelRefreshed>(_onArticleChannelRefreshed);
  }

  Future<void> _onArticleStarted(
      ArticleEvent event, Emitter<ArticleState> emitter) async {
    await articleRepository.syncArticles();

    // emitter(ArticleState.ready(channel: "", articles: []));
  }

  Future<void> _onArticleRequested(
      ArticleRequested event, Emitter<ArticleState> emitter) async {
    List<Article> articles =
        await articleRepository.queryByLink(event.channel.link);
    emitter(ArticleState.ready(channel: event.channel, articles: articles));
  }

  Future<void> _onArticleChannelRefreshed(
      ArticleChannelRefreshed event, Emitter<ArticleState> emitter) async {
    await articleRepository.syncArticlesByChannel(event.channel);
    List<Article> articles =
        await articleRepository.queryByLink(event.channel.link);
    emitter(ArticleState.ready(channel: event.channel, articles: articles));
  }
}
