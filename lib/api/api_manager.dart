import 'package:dio/dio.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/model/sources_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract final class ApiManager {
  static const _apiKey = "337dc2b5fe7c467aacde1b358cbe785b";
  static final _dio = Dio(BaseOptions(baseUrl: "https://newsapi.org",));
  static const _defaultErrorMessage =
      "Something went wrong please try again later";

  static Future<List<SourceDM>> loadSources(String category) async {
    _dio.interceptors.add(PrettyDioLogger());
    try {
      var serverResponse =
          await _dio.get("/v2/top-headlines/sources?apiKey=$_apiKey&category=$category");
      if (serverResponse.statusCode! >= 200 &&
          serverResponse.statusCode! < 300) {
        Map<String, dynamic> json = serverResponse.data;
        var myResponse = SourcesResponse.fromJson(json);
        return myResponse.sources!;
      }
      throw _defaultErrorMessage;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ArticleDM>> loadArticles(String sourceId) async {
    try {
      var serverResponse = await _dio.get("/v2/everything",
          queryParameters: {"apiKey": _apiKey, "sources": sourceId});
      if (serverResponse.statusCode! >= 200 &&
          serverResponse.statusCode! < 300) {
        Map<String, dynamic> json = serverResponse.data;
        var myResponse = ArticlesResponse.fromJson(json);
        return myResponse.articles!;
      }
      throw _defaultErrorMessage;
    } catch (e) {
      rethrow;
    }
  }
}
