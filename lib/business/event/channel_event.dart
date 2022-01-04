import 'package:equatable/equatable.dart';
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

class PartialChannelRefreshStarted extends ChannelEvent {
  // here Object represents Channel|ChannelGroup
  final List<Object> channels;
  PartialChannelRefreshStarted(this.channels);
  @override
  List<Object?> get props => [channels];
}

class PartialChannelRefreshFinished extends ChannelEvent {
  PartialChannelRefreshFinished();
  @override
  List<Object?> get props => [];
}

class ChannelRefreshStarted extends ChannelEvent {
  ChannelRefreshStarted();
  @override
  List<Object?> get props => [];
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
