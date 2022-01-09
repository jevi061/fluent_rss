import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/business/blocs/article/article_state.dart';
import 'package:fluent_rss/business/blocs/channel/channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
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
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: state.articles.length,
                itemBuilder: (context, index) => ArticleTile(
                      article: state.articles[index],
                    )),
          ),
          onRefresh: () async {
            final channelBloc = BlocProvider.of<ChannelBloc>(context)
              ..add(ChannelRefreshStarted(channel));
            await channelBloc.stream
                .firstWhere((element) => element is ChannelRefreshedState);
            BlocProvider.of<ArticleBloc>(context)
                .add(ArticleRequested(channelLink: channel.link));
          },
        ),
      );
    });
  }
}
