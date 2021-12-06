import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class ArticleEvent extends Equatable {}

class ArticleStarted extends ArticleEvent {
  @override
  List<Object?> get props => [];
}

class ArticleRequested extends ArticleEvent {
  Channel channel;
  ArticleRequested({required this.channel});
  @override
  List<Object?> get props => [channel];
}

class ArticleChannelUpdated extends ArticleEvent {
  @override
  List<Object?> get props => [];
}
