import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_c19/data/repository/search_repository/data_sources/remote_data_source/search_remote_data_source.dart';
import 'package:news_c19/data/repository/search_repository/search_repository.dart';
import 'package:news_c19/model/articles_response.dart';

/// Search results are not cached, so there is no local data source here.
class SearchRepositoryImpl extends SearchRepository {
  SearchRemoteDataSource searchRemoteDataSource;
  static const _noInternetMessage =
      "Please check your internet connection and try again";

  SearchRepositoryImpl({required this.searchRemoteDataSource});

  @override
  Future<List<ArticleDM>> loadTopHeadlines() async {
    if (await isOnline()) {
      return searchRemoteDataSource.loadTopHeadlines();
    } else {
      throw _noInternetMessage;
    }
  }

  @override
  Future<List<ArticleDM>> searchArticles(String query) async {
    if (await isOnline()) {
      return searchRemoteDataSource.searchArticles(query);
    } else {
      throw _noInternetMessage;
    }
  }

  Future<bool> isOnline() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
