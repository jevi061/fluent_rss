import 'dart:async';

import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelRepository channelRepository;
  ArticleRepository articleRepository;
  ChannelBloc(
      {required this.channelRepository, required this.articleRepository})
      : super(ChannelReadyState(channels: [])) {
    on<ChannelStarted>(_onChannelStarted);
    on<ChannelUpdated>(_onChannelUpdated);
    on<ChannelOpened>(_onChannelOpened);
    on<PartialChannelRefreshStarted>(_onPartialChannelRefreshStarted);
    on<ChannelRefreshStarted>(_onChannelRefreshStarted);
    on<ChannelRefreshFinished>(_onChannelRefreshFinished);
    on<ChannelDeleted>(_onChannelDeleted);
    on<ChannelAdded>(_onChannelAdded);
    on<ChannelImported>(_onChannelImported);
    on<ChannelStatusChanged>(_onChannelStatusChanged);
  }

  Future<void> _onChannelStarted(
      ChannelEvent event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  Future<void> _onChannelStatusChanged(
      ChannelEvent event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  Future<void> _onChannelUpdated(
      ChannelUpdated event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  void _onChannelOpened(
      ChannelOpened event, Emitter<ChannelState> emitter) async {}
  Future<void> _onPartialChannelRefreshStarted(
      PartialChannelRefreshStarted event, Emitter<ChannelState> emitter) async {
    emitter
        .forEach(channelRepository.refreshChannelsWithProgress(event.channels),
            onData: (double percent) {
      AppLogger.instance.d("refresh progress is :$percent");
      return ChannelRefreshingState(progress: percent);
    });
    add(ChannelRefreshFinished());
  }

  Future<void> _onChannelRefreshStarted(
      ChannelRefreshStarted event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter.forEach(channelRepository.refreshChannelsWithProgress(channels),
        onData: (double percent) {
      AppLogger.instance.d("refresh progress is :$percent");
      return ChannelRefreshingState(progress: percent);
    });
    add(ChannelRefreshFinished());
  }

  Future<void> _onChannelRefreshFinished(
      ChannelRefreshFinished event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  void _onChannelDeleted(
      ChannelDeleted event, Emitter<ChannelState> emitter) async {
    await channelRepository.removeChannel(event.channel.link);
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  void _onChannelAdded(
      ChannelAdded event, Emitter<ChannelState> emitter) async {
    await channelRepository.addChannel(event.channel);
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
    add(PartialChannelRefreshStarted([event.channel]));
  }

  void _onChannelImported(
      ChannelImported event, Emitter<ChannelState> emitter) async {
    await channelRepository.addChannels(event.channels);
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
    add(PartialChannelRefreshStarted(event.channels));
  }
}
