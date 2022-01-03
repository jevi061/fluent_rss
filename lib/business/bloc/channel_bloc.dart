import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/domains/channel_group.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/category_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/services/opml_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_saver/file_saver.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelRepository channelRepository;
  ArticleRepository articleRepository;
  CategoryRepository categoryRepository;
  ChannelBloc(
      {required this.channelRepository,
      required this.articleRepository,
      required this.categoryRepository})
      : super(ChannelReadyState(channels: [])) {
    on<ChannelStarted>(_onChannelStarted);
    on<ChannelUpdated>(_onChannelUpdated);
    on<ChannelOpened>(_onChannelOpened);
    on<PartialChannelRefreshStarted>(_onPartialChannelRefreshStarted);
    on<PartialChannelRefreshFinished>(_onPartialChannelRefreshFished);
    on<ChannelRefreshStarted>(_onChannelRefreshStarted);
    on<ChannelRefreshFinished>(_onChannelRefreshFinished);
    on<ChannelDeleted>(_onChannelDeleted);
    on<ChannelAdded>(_onChannelAdded);
    on<ChannelImported>(_onChannelImported);
    on<ChannelStatusChanged>(_onChannelStatusChanged);
    on<ChannelsExportStarted>(_onChannelsExportStarted);
    on<ChannelsExportFinished>(_onChannelsExportFinished);
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
    await emitter
        .forEach(channelRepository.refreshChannelsWithProgress(event.channels),
            onData: (double percent) {
      AppLogger.instance.d("partial refresh progress is :$percent");
      return ChannelRefreshingState(progress: percent);
    });
    add(PartialChannelRefreshFinished());
  }

  Future<void> _onPartialChannelRefreshFished(
      PartialChannelRefreshFinished event,
      Emitter<ChannelState> emitter) async {
    emitter(PartialChannelRefreshedState());
    AppLogger.instance.d("particle channel refresh finished-----");
  }

  Future<void> _onChannelRefreshStarted(
      ChannelRefreshStarted event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    await emitter
        .forEach(channelRepository.refreshChannelsWithProgress(channels),
            onData: (double percent) {
      AppLogger.instance.d("full refresh progress is :$percent");
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
    await channelRepository.deleteChannelByLink(event.channel.link);
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
    // add channels
    var unCategorizedChannels = event.channels.whereType<Channel>().toList();
    await channelRepository.addChannels(unCategorizedChannels);
    // add channelGroups
    var channelGroups = event.channels.whereType<ChannelGroup>().toList();
    for (var item in channelGroups) {
      var categoryId = await categoryRepository.addCategory(item.category);
      item.channels.forEach((element) {
        element.categoryId = categoryId;
      });
      await channelRepository.addChannels(item.channels);
    }
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
    add(PartialChannelRefreshStarted(event.channels));
  }

  void _onChannelsExportStarted(
      ChannelsExportStarted event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    var opml = await OPMLBuilder.buildOPML(channels);
    var path = await FileSaver.instance.saveFile(
      "fluent_rss",
      utf8.encode(opml) as Uint8List,
      "opml",
    );
    AppLogger.instance.d("export opml to:$path");
    add(ChannelsExportFinished(path));
  }

  void _onChannelsExportFinished(
      ChannelsExportFinished event, Emitter<ChannelState> emitter) async {
    emitter(
        ChannelsExportedState(path: event.path, exportedAt: DateTime.now()));
  }
}
