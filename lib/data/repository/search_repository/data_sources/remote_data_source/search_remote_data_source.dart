import 'package:news_c19/model/articles_response.dart';

abstract class SearchRemoteDataSource {
  Future<List<ArticleDM>> loadTopHeadlines();

  Future<List<ArticleDM>> searchArticles(String query);
}
