import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/data/repository/news_repository/data_sources/local_data_source/news_local_data_source_impl2.dart';
import 'package:news_c19/data/repository/news_repository/data_sources/remote_data_source/news_remote_data_source_impl.dart';
import 'package:news_c19/data/repository/news_repository/news_repository_impl.dart';
import 'package:news_c19/model/category_dm.dart';
import 'package:news_c19/model/sources_response.dart';
import 'package:news_c19/ui/screens/news/articles_list.dart';
import 'package:news_c19/ui/screens/news/news_viewmodel.dart';

import '../../widgets/app_drawer.dart';

class NewsScreen extends StatefulWidget {
  final CategoryDM categoryDM;

  const NewsScreen(this.categoryDM, {super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsViewModel viewModel = NewsViewModel(
    newsRepository: NewsRepositoryImpl(
        newsRemoteDataSource: NewsRemoteDataSourceImpl(),
        newsLocalDataSource: NewsLocalDataSourceImpl2())
  );

  @override
  void initState() {
    super.initState();
    viewModel.loadSources(widget.categoryDM.name);
  }
  /// Cubit - mvvm
  ///ChangeNotifierProvider -> BlocProvider
  ///Consumer -> BlocBuilder
  // BlocListener
  // BlocConsumer -> BlocBuilder + BlocListener
  ///Provider.of(context) -> BlocProvider(context)
  @override
  Widget build(BuildContext context) {
    // BlocListener<NewsViewModel, NewsState>(
    //   listener: (context, state){
    //   },
    //   child: Scaffold(),
    // );
    Widget body;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryDM.name),
        ),
        drawer: AppDrawer(showGoToHomeNavigation: true),
        body: BlocBuilder<NewsViewModel, NewsState>(
          /// Use this pattern only if the viewmodel is used in this widget only
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
    if(sources.isEmpty) return Center(child: Text("No sources in this category"),);
    // var nums = [1, 2 ,3];
    // nums.map((num) => num.toString()).toList()

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
