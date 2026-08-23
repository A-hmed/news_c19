import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/sources_response.dart';

class NewsState {
  List<SourceDM> sources = [];
  bool isLoading = false;
  var errorMessage = '';

  NewsState(
      {this.sources = const [],
      this.isLoading = false,
      this.errorMessage = ''});
}

class NewsViewModel extends Cubit<NewsState> {
  NewsViewModel() : super(NewsState());

  loadSources(String category) async {
    try {
      emit(NewsState(isLoading: true));
      var sources = await ApiManager.loadSources(category);
      emit(NewsState(sources: sources));
    } catch (e) {
      emit(NewsState(errorMessage: e.toString()));
    }
  }
}
