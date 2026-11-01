import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final ArticleDM articleDM;

  const ArticleDetailsScreen(this.articleDM, {super.key});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  WebViewController controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.articleDM.url == null) return;
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.articleDM.url!));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.articleDM.source?.name ?? ""),
        ),
        body: widget.articleDM.url == null
            ? Center(child: Text("This article has no link"))
            : Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (isLoading) Center(child: CircularProgressIndicator()),
                ],
              ),
      ),
    );
  }
}
