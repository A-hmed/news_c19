import 'package:hive_flutter/adapters.dart';
import 'package:news_c19/data/repository/news_repository/data_sources/local_data_source/news_local_data_source.dart';
import 'package:news_c19/model/sources_response.dart';

///Flutter sqlflite
///Hive
///Isar
///Shared pref (key -> value)
///Firestore
class NewsLocalDataSourceImpl extends NewsLocalDataSource {
  Future<List<SourceDM>> loadSources(String category) async {
    var box = await Hive.openBox("news");
    var sources = box.get(category) as List<SourceDM>?;
    return sources ?? [];
  }

  Future<void> saveSource(String category, List<SourceDM> sources) async {
    var box = await Hive.openBox("news");
    box.put(category, sources);
  }
}
