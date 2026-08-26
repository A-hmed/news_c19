import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:news_c19/ui/widgets/searched_artical_widget.dart';

import '../../api/api_manager.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  late Future<List<ArticleDM>> articles;

  @override
  void initState() {
    super.initState();
    articles = ApiManager.loadAllArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildSearchWidget(),
            const SizedBox(height: 16.0),
            SearchedArticleWidget(searchText: searchText, articles: articles),
          ],
        ),
      ),
    );
  }

  Widget buildSearchWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: context.theme.secondaryColor)),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {});
            searchText = value;
          },
          style: context.theme.textTheme.titleMedium!.copyWith(fontSize: 20),
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle:
                context.theme.textTheme.titleMedium!.copyWith(fontSize: 20),
            prefixIcon: Icon(
              Icons.search,
              color: context.theme.secondaryColor,
              size: 24,
            ),
            suffixIcon: InkWell(
              onTap: () {
                Navigator.pop(context);
                _searchController.clear();
                searchText = "";
              },
              child: Icon(
                Icons.close,
                color: context.theme.secondaryColor,
                size: 24,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
