import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/favorite/favorite_bloc.dart';
import 'package:fluent_rss/business/blocs/read/reading_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/business/blocs/favorite/favorite_event.dart';
import 'package:fluent_rss/business/blocs/read/reading_state.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingScreen extends StatefulWidget {
  ReadingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadingScreen> {
  double loadProgress = 10;
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
        builder: (BuildContext context, ReadingState state) {
      return Scaffold(
        appBar: AppBar(title: Text(state.article?.title ?? "")),
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: state.article?.link ?? "",
              onProgress: (int progress) {
                setState(() {
                  AppLogger.instance.d("loading progress:$progress");
                  loadProgress = progress.toDouble();
                });
              },
              onPageFinished: (url) {
                if (state.article?.status?.read == 0) {
                  context.read<ChannelBloc>().add(ChannelStatusChanged());
                }
                setState(() {
                  loadProgress = 100.0;
                });
              },
              onWebViewCreated: (controller) {
                _controller = controller;
              },
            ),
            loadProgress == 100
                ? Stack()
                : LinearProgressIndicator(
                    value: loadProgress / 100,
                  ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    _controller?.goBack();
                  },
                  icon: Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {
                    _controller?.goForward();
                  },
                  icon: Icon(Icons.arrow_forward)),
              IconButton(
                  onPressed: () {
                    _controller?.reload();
                  },
                  icon: Icon(Icons.refresh)),
              IconButton(
                  onPressed: () {
                    state.article?.status?.starred == 0
                        ? state.article?.status?.starred = 1
                        : state.article?.status?.starred = 0;
                    context
                        .read<ArticleBloc>()
                        .add(ArticleStarred(state.article!));
                    context
                        .read<FavoriteBloc>()
                        .add(FavoriteUpdated(article: state.article!));
                    setState(() {});
                  },
                  icon: state.article?.status?.starred == 0
                      ? Icon(Icons.star_border)
                      : Icon(Icons.star)),
              IconButton(
                  onPressed: () {
                    Share.share(
                        state.article!.title + '\n' + state.article!.link);
                  },
                  icon: Icon(Icons.share)),
              IconButton(
                  onPressed: () {
                    launch(state.article!.link);
                  },
                  icon: Icon(Icons.open_in_browser))
            ],
          ),
        ),
      );
    });
  }
}
