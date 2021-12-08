import 'dart:async';

import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:collection/collection.dart";

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelRepository channelRepository;
  ChannelBloc({required this.channelRepository})
      : super(ChannelReadyState(channels: [])) {
    on<ChannelStarted>(_onChannelStarted);
    on<ChannelUpdated>(_onChannelUpdated);
    on<ChannelOpened>(_onChannelOpened);
    on<ChannelRefreshed>(_onChannelRefreshed);
  }

  Future<void> _onChannelStarted(
      ChannelEvent event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  Future<void> _onChannelUpdated(
      ChannelUpdated event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    channelRepository.syncChannelArticles(event.channels);
    emitter(ChannelReadyState(channels: channels));
  }

  void _onChannelOpened(
      ChannelOpened event, Emitter<ChannelState> emitter) async {}
  void _onChannelRefreshed(
      ChannelRefreshed event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    // Map<String, List<Channel>> groupedChannels =
    //     groupBy(channels, (Channel ch) => ch.directory);
    emitter(ChannelReadyState(channels: channels));
  }
}
