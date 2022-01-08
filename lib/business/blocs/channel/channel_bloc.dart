import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/domains/channel_group.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/category_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/services/opml_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<ChannelRefreshStarted>(_onChannelRefreshStarted);
    on<PartialChannelsRefreshStarted>(_onPartialChannelsRefreshStarted);
    on<PartialChannelsRefreshFinished>(_onPartialChannelsRefreshFished);
    on<AllChannelsRefreshStarted>(_onAllChannelsRefreshStarted);
    on<AllChannelsRefreshFinished>(_onAllChannelsRefreshFinished);
    on<ChannelDeleted>(_onChannelDeleted);
    on<ChannelBatchDeleteRequested>(_onChannelBatchDeleteRequested);
    on<ChannelAdded>(_onChannelAdded);
    on<ChannelImported>(_onChannelImported);
    on<ChannelStatusChanged>(_onChannelStatusChanged);
    on<ChannelsExportStarted>(_onChannelsExportStarted);
    on<ChannelsExportFinished>(_onChannelsExportFinished);
    on<ChannelRequested>(_onChannelRequested);
    on<ChannelChangeCategoryRequested>(_onChannelChangeCategoryRequested);
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
  Future<void> _onChannelRefreshStarted(
      ChannelRefreshStarted event, Emitter<ChannelState> emitter) async {
    await channelRepository.syncChannel(event.channel);
    emitter(ChannelRefreshedState(event.channel));
  }

  Future<void> _onPartialChannelsRefreshStarted(
      PartialChannelsRefreshStarted event,
      Emitter<ChannelState> emitter) async {
    await emitter
        .forEach(channelRepository.refreshChannelsWithProgress(event.channels),
            onData: (double percent) {
      AppLogger.instance.d("partial refresh progress is :$percent");
      return ChannelRefreshingState(progress: percent);
    });
    add(PartialChannelsRefreshFinished());
  }

  Future<void> _onPartialChannelsRefreshFished(
      PartialChannelsRefreshFinished event,
      Emitter<ChannelState> emitter) async {
    emitter(PartialChannelsRefreshedState());
    AppLogger.instance.d("particle channel refresh finished-----");
  }

  Future<void> _onAllChannelsRefreshStarted(
      AllChannelsRefreshStarted event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    await emitter
        .forEach(channelRepository.refreshChannelsWithProgress(channels),
            onData: (double percent) {
      AppLogger.instance.d("full refresh progress is :$percent");
      return ChannelRefreshingState(progress: percent);
    });
    add(AllChannelsRefreshFinished());
  }

  Future<void> _onAllChannelsRefreshFinished(
      AllChannelsRefreshFinished event, Emitter<ChannelState> emitter) async {
    List<Channel> channels = await channelRepository.fetchChannels();
    emitter(ChannelReadyState(channels: channels));
  }

  Future<void> _onChannelBatchDeleteRequested(
      ChannelBatchDeleteRequested event, Emitter<ChannelState> emitter) async {
    for (var channel in event.channels) {
      await channelRepository.deleteChannelByLink(channel.link);
    }
    List<Channel> channels =
        await channelRepository.getChannelsByCategory(event.category.id ?? 0);
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
    add(PartialChannelsRefreshStarted([event.channel]));
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
    add(PartialChannelsRefreshStarted(event.channels));
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

  void _onChannelRequested(
      ChannelRequested event, Emitter<ChannelState> emitter) async {
    List<Channel> channels =
        await channelRepository.getChannelsByCategory(event.categoryId);
    emitter(ChannelReadyState(channels: channels));
  }

  Future<void> _onChannelChangeCategoryRequested(
      ChannelChangeCategoryRequested event,
      Emitter<ChannelState> emitter) async {
    AppLogger.instance.d(
        "change channels category,new categoryId:${event.currentCategory.id}");
    await channelRepository.changeChannelsCategory(
        event.channels, event.currentCategory.id!);
    List<Channel> channels = await channelRepository
        .getChannelsByCategory(event.previousCategory.id ?? 0);
    emitter(ChannelReadyState(channels: channels));
  }
}
