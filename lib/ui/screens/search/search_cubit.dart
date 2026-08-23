import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/articles_response.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ArticleDM> articles;
  SearchSuccess(this.articles);
}

class SearchError extends SearchState {
  final String errorMessage;
  SearchError(this.errorMessage);
}

class SearchEmpty extends SearchState {}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Timer? _debounceTimer;

  void searchArticles(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());
      try {
        final articles = await ApiManager.searchArticles(query);
        if (articles.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchSuccess(articles));
        }
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
