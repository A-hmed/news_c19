import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/data/repository/search_repository/data_sources/remote_data_source/search_remote_data_source.dart';
import 'package:news_c19/model/articles_response.dart';

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  @override
  Future<List<ArticleDM>> loadTopHeadlines() {
    return ApiManager.loadTopHeadlines();
  }

  @override
  Future<List<ArticleDM>> searchArticles(String query) {
    return ApiManager.searchArticles(query);
  }
}
