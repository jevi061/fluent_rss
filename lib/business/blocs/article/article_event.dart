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

class ArticleStarTriggered extends ArticleEvent {
  final Article article;
  final int currentStar;
  ArticleStarTriggered({required this.article, required this.currentStar});
  @override
  List<Object?> get props => [];
}

class ArticleRead extends ArticleEvent {
  int previousRead;
  Article article;
  ArticleRead({required this.article, required this.previousRead});
  @override
  List<Object?> get props => [];
}

class ArticleStatusChanged extends ArticleEvent {
  Article article;
  ArticleStatusChanged(this.article);
  @override
  List<Object?> get props => [];
}
