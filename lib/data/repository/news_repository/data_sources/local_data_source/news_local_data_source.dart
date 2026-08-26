import 'package:hive_flutter/adapters.dart';
import 'package:news_c19/model/sources_response.dart';

///Flutter sqlflite
///Hive
///Isar
///Shared pref (key -> value)
///Firestore
abstract class NewsLocalDataSource {
  Future<List<SourceDM>> loadSources(String category);

  Future<void> saveSource(String category, List<SourceDM> sources);
}


