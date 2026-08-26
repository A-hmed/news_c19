import 'package:news_c19/data/repository/news_repository/data_sources/local_data_source/news_local_data_source_impl.dart';
import 'package:news_c19/data/repository/news_repository/data_sources/remote_data_source/news_remote_data_source.dart';
import 'package:news_c19/data/repository/news_repository/data_sources/remote_data_source/news_remote_data_source_impl.dart';
import 'package:news_c19/data/repository/news_repository/news_repository_impl.dart';
import 'package:news_c19/model/sources_response.dart';

main(){
  NewsRepositoryImpl newsRepositoryImpl = NewsRepositoryImpl(
      newsRemoteDataSource: MockNewsRemoteDataSource(),
      newsLocalDataSource: NewsLocalDataSourceImpl());
}

class MockNewsRemoteDataSource extends NewsRemoteDataSource{
  @override
  Future<List<SourceDM>> loadSources(String category) async {
    return [];
  }

}