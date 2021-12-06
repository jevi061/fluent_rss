import 'dart:async';

import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'app_bloc.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelRepository channelRepository;
  ChannelBloc({required this.channelRepository})
      : super(ChannelState.ready(channels: [])) {
    on<ChannelStarted>(_onChannelStarted);
    on<ChannelUpdated>(_onChannelStarted);
    on<ChannelOpened>(_onChannelOpened);
  }

  Future<void> _onChannelStarted(
      ChannelEvent event, Emitter<ChannelState> emitter) async {
    List<Channel>? channels = await channelRepository.fetchChannels();
    emitter(ChannelState.ready(channels: channels ?? []));
  }

  void _onChannelOpened(
      ChannelOpened event, Emitter<ChannelState> emitter) async {}
}
