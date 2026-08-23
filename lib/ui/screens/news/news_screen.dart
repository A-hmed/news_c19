import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/model/category_dm.dart';
import 'package:news_c19/model/sources_response.dart';
import 'package:news_c19/ui/screens/news/articles_list.dart';
import 'package:news_c19/ui/screens/news/news_viewmodel.dart';
import 'package:news_c19/ui/utils/app_routes.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

import '../../widgets/app_drawer.dart';

class NewsScreen extends StatefulWidget {
  final CategoryDM categoryDM;

  const NewsScreen(this.categoryDM, {super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsViewModel viewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadSources(widget.categoryDM.name);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    var theme = context.theme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryDM.name),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: theme.secondaryColor),
              onPressed: () {
                Navigator.push(context, AppRoutes.search());
              },
            ),
          ],
        ),
        drawer: AppDrawer(showGoToHomeNavigation: true),
        body: BlocBuilder<NewsViewModel, NewsState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state.isLoading) {
              body = Center(child: CircularProgressIndicator());
            } else if (state.errorMessage.isNotEmpty) {
              body = Text(
                state.errorMessage,
                style: TextStyle(color: Colors.white),
              );
            } else {
              body = buildTabBar(state.sources);
            }
            return body;
          },
        ),
      ),
    );
  }

  Widget buildTabBar(List<SourceDM> sources) {
    var tabs = sources.map((source) => Text(source.name ?? "Unknown")).toList();
    var articlesList =
        sources.map((source) => ArticlesList(sourceId: source.id!)).toList();

    return DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            TabBar(
              tabs: tabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
            ),
            Expanded(child: TabBarView(children: articlesList))
          ],
        ));
  }
}
