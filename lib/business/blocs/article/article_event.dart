import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class ArticleEvent extends Equatable {}

class ArticleStarted extends ArticleEvent {
  @override
  List<Object?> get props => [];
}

class ArticleRequested extends ArticleEvent {
  String channelLink;
  ArticleRequested({required this.channelLink});
  @override
  List<Object?> get props => [channelLink];
}

class ArticleChannelUpdated extends ArticleEvent {
  @override
  List<Object?> get props => [];
}

class ArticleChannelRefreshStarted extends ArticleEvent {
  Channel channel;
  ArticleChannelRefreshStarted({required this.channel});
  @override
  List<Object?> get props => [channel];
}

class ArticleChannelRefreshFinished extends ArticleEvent {
  Channel channel;
  ArticleChannelRefreshFinished({required this.channel});
  @override
  List<Object?> get props => [channel];
}

class ArticleChannelRefreshed extends ArticleEvent {
  Channel channel;
  ArticleChannelRefreshed({required this.channel});
  @override
  List<Object?> get props => [channel];
}

class ArticleStarred extends ArticleEvent {
  Article article;
  ArticleStarred(this.article);
  @override
  List<Object?> get props => [];
}

class ArticleRead extends ArticleEvent {
  Article article;
  ArticleRead(this.article);
  @override
  List<Object?> get props => [];
}

class ArticleStatusChanged extends ArticleEvent {
  ArticleStatusChanged();
  @override
  List<Object?> get props => [];
}
