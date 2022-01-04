import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/state/article_state.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleScreen extends StatelessWidget {
  ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Channel channel = ModalRoute.of(context)?.settings.arguments as Channel;
    return BlocBuilder<ArticleBloc, ArticleState>(
        builder: (BuildContext context, ArticleState state) {
      return Scaffold(
        appBar: AppBar(title: Text(channel.title)),
        body: RefreshIndicator(
          child: Scrollbar(
            controller: ScrollController(),
            child: ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) => ArticleTile(
                      article: state.articles[index],
                    )),
          ),
          onRefresh: () async {
            final channelBloc = BlocProvider.of<ChannelBloc>(context)
              ..add(PartialChannelRefreshStarted([channel]));
            await channelBloc.stream.firstWhere(
                (element) => element is PartialChannelRefreshedState);
          },
        ),
      );
    });
  }
}
