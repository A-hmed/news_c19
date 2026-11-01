import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/data/repository/search_repository/data_sources/remote_data_source/search_remote_data_source_impl.dart';
import 'package:news_c19/data/repository/search_repository/search_repository_impl.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/screens/search/search_viewmodel.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:news_c19/ui/widgets/article_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchViewModel viewModel = SearchViewModel(
      searchRepository: SearchRepositoryImpl(
          searchRemoteDataSource: SearchRemoteDataSourceImpl()));
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.loadTopHeadlines();
  }

  @override
  void dispose() {
    searchController.dispose();
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            buildSearchField(),
            Expanded(
              child: BlocBuilder<SearchViewModel, SearchState>(
                bloc: viewModel,
                builder: (context, state) {
                  if (state.isLoading) {
                    body = Center(child: CircularProgressIndicator());
                  } else if (state.errorMessage.isNotEmpty) {
                    body = Center(
                        child: Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    body = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: buildArticlesListView(state.articles),
                    );
                  }
                  return body;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchField() {
    var theme = context.theme;
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: theme.secondaryColor),
    );
    var textStyle = theme.textTheme.bodySmall!.copyWith(fontSize: 20);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        cursorColor: theme.secondaryColor,
        style: textStyle,
        onSubmitted: (query) {
          viewModel.search(query);
        },
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: textStyle,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
          prefixIcon: Icon(Icons.search, color: theme.secondaryColor),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: theme.secondaryColor),
          ),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }

  Widget buildArticlesListView(List<ArticleDM> articles) {
    if (articles.isEmpty) {
      return Center(
        child: Text("No articles found"),
      );
    }
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) =>
            ArticleWidget(articleDM: articles[index]));
  }
}
