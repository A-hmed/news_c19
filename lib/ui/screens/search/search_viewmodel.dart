import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/data/repository/search_repository/search_repository.dart';
import 'package:news_c19/model/articles_response.dart';

class SearchState {
  List<ArticleDM> articles = [];
  bool isLoading = false;
  var errorMessage = '';

  SearchState(
      {this.articles = const [],
      this.isLoading = false,
      this.errorMessage = ''});
}

class SearchViewModel extends Cubit<SearchState> {
  SearchRepository searchRepository;
  SearchViewModel({required this.searchRepository}) : super(SearchState());

  loadTopHeadlines() async {
    try {
      emit(SearchState(isLoading: true));
      var articles = await searchRepository.loadTopHeadlines();
      emit(SearchState(articles: articles));
    } catch (e) {
      emit(SearchState(errorMessage: e.toString()));
    }
  }

  search(String query) async {
    if (query.trim().isEmpty) return;
    try {
      emit(SearchState(isLoading: true));
      var articles = await searchRepository.searchArticles(query.trim());
      emit(SearchState(articles: articles));
    } catch (e) {
      emit(SearchState(errorMessage: e.toString()));
    }
  }
}
