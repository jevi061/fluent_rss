import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/favorite_bloc.dart';
import 'package:fluent_rss/business/bloc/reading_bloc.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/favorite_event.dart';
import 'package:fluent_rss/business/state/reading_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                  Logger().d("loading progress:$progress");
                  loadProgress = progress.toDouble();
                });
              },
              onPageFinished: (url) {
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
                    state.article?.starred == 0
                        ? state.article?.starred = 1
                        : state.article?.starred = 0;
                    context
                        .read<ArticleBloc>()
                        .add(ArticleStarred(state.article!));
                    context
                        .read<FavoriteBloc>()
                        .add(FavoriteUpdated(article: state.article!));
                    setState(() {});
                  },
                  icon: state.article?.starred == 0
                      ? Icon(Icons.star_border)
                      : Icon(Icons.star)),
              IconButton(onPressed: () {}, icon: Icon(Icons.share))
            ],
          ),
        ),
      );
    });
  }
}
