import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_c19/data/hive_adapters/source_dm_adapter.dart';
import 'package:news_c19/ui/screens/news/news_screen.dart';
import 'package:news_c19/ui/screens/splash/splash_screen.dart';
import 'package:news_c19/ui/utils/app_theme.dart';

import 'data/repository/news_repository/data_sources/local_data_source/news_local_data_source.dart';


/// Widget -> VM -> Repo -> [LocalDataSource - RemoteDataSource]
void main() async{
  Hive.initFlutter();
  Hive.registerAdapter(SourceDMAdapter());
  runApp(const MyApp());
}
///Bloc - Provider - GetX
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      home: SplashScreen(),
    );
  }
}

///News task list:
///1- Implement search screen use everything api
///2- Implement article details bottom sheet
///3- Add Pagination for everything api



///HTTP Request:
/// Type: GET - POST - PATCH - DELETE ...
/// Link: (Base url)/EndPoint(API)/PathVariables?QueryParameters
/// Body: JSON - XML - HTML...
/// Headers: JSON
/// ----------------------------------
/// HTTP RESPONSE:
/// - Headers
/// - Body
/// - status code (int)
