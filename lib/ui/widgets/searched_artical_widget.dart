import 'package:flutter/material.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

import '../../model/articles_response.dart';
import 'article_widget.dart';

class SearchedArticleWidget extends StatelessWidget {
  final String searchText;
  final Future<List<ArticleDM>> articles;

  const SearchedArticleWidget(
      {super.key, required this.searchText, required this.articles});

  @override
  Widget build(BuildContext context) {
    var title = "";
    return Expanded(
      child: FutureBuilder<List<ArticleDM>>(
          // Replace dynamic with your Article model
          future: articles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: context.theme.secondaryColor,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final List<ArticleDM> filteredArticles =
                  snapshot.data!.where((article) {
                title = article.description?.toLowerCase() ?? '';
                return title.contains(searchText.toLowerCase());
              }).toList();

              if (filteredArticles.isEmpty) {
                return const Center(child: Text("No results found"));
              }
              return ListView.builder(
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  return ArticleWidget(
                    articleDM: filteredArticles[index],
                  );
                },
              );
            }
          }),
    );
  }
}
