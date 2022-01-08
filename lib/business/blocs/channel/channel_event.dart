import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class ChannelEvent extends Equatable {}

class ChannelReady extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class ChannelUpdated extends ChannelEvent {
  List<Channel> channels;
  ChannelUpdated(this.channels);
  @override
  List<Object?> get props => [channels];
}

class ChannelStarted extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class ChannelOpened extends ChannelEvent {
  Channel channel;
  ChannelOpened(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelStatusChanged extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class PartialChannelsRefreshStarted extends ChannelEvent {
  // here Object represents Channel|ChannelGroup
  final List<Object> channels;
  PartialChannelsRefreshStarted(this.channels);
  @override
  List<Object?> get props => [channels];
}

class PartialChannelsRefreshFinished extends ChannelEvent {
  PartialChannelsRefreshFinished();
  @override
  List<Object?> get props => [];
}

class AllChannelsRefreshStarted extends ChannelEvent {
  AllChannelsRefreshStarted();
  @override
  List<Object?> get props => [];
}

class AllChannelsRefreshFinished extends ChannelEvent {
  AllChannelsRefreshFinished();
  @override
  List<Object?> get props => [];
}

class ChannelRefreshStarted extends ChannelEvent {
  final Channel channel;
  ChannelRefreshStarted(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelRefreshFinished extends ChannelEvent {
  ChannelRefreshFinished();
  @override
  List<Object?> get props => [];
}

class ChannelDeleted extends ChannelEvent {
  Channel channel;
  ChannelDeleted(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelBatchDeleteRequested extends ChannelEvent {
  Category category;
  List<Channel> channels;
  ChannelBatchDeleteRequested({required this.channels, required this.category});
  @override
  List<Object?> get props => [category, channels];
}

class ChannelAdded extends ChannelEvent {
  Channel channel;
  ChannelAdded(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelImported extends ChannelEvent {
  // here Object represents Channel|ChannelGroup
  List<Object> channels;
  ChannelImported(this.channels);
  @override
  List<Object?> get props => [channels];
}

class ChannelsExportStarted extends ChannelEvent {
  ChannelsExportStarted();
  @override
  List<Object?> get props => [];
}

class ChannelsExportFinished extends ChannelEvent {
  String path;
  ChannelsExportFinished(this.path);
  @override
  List<Object?> get props => [path];
}

class ChannelRequested extends ChannelEvent {
  final int categoryId;
  ChannelRequested(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class ChannelChangeCategoryRequested extends ChannelEvent {
  final Category previousCategory;
  final Category currentCategory;
  final List<Channel> channels;
  ChannelChangeCategoryRequested(
      {required this.previousCategory,
      required this.currentCategory,
      required this.channels});
  @override
  List<Object?> get props => [previousCategory, currentCategory, channels];
}
