import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/ui/screens/search/search_cubit.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:news_c19/ui/widgets/article_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocProvider<SearchCubit>(
      create: (_) => SearchCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<SearchCubit>();

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.secondaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: TextStyle(
                  color: theme.secondaryColor,
                  fontSize: 18,
                ),
                cursorColor: theme.secondaryColor,
                decoration: InputDecoration(
                  hintText: "Search articles...",
                  hintStyle: TextStyle(
                    color: theme.secondaryColor.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (query) => cubit.searchArticles(query),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.clear, color: theme.secondaryColor),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _searchController.clear();
                      cubit.searchArticles('');
                    }
                  },
                ),
              ],
            ),
            body: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.secondaryColor,
                    ),
                  );
                } else if (state is SearchSuccess) {
                  return ListView.builder(
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) =>
                        ArticleWidget(articleDM: state.articles[index]),
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: theme.secondaryColor),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: theme.secondaryColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is SearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline,
                            size: 64, color: theme.secondaryColor),
                        const SizedBox(height: 16),
                        Text(
                          "No results found for your search.",
                          style: TextStyle(
                              color: theme.secondaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search,
                            size: 64,
                            color: theme.secondaryColor.withValues(alpha: 0.4)),
                        const SizedBox(height: 16),
                        Text(
                          "Type to search for articles...",
                          style: TextStyle(
                            color: theme.secondaryColor.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
