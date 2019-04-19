import 'dart:async';

import '../models/item_model.dart';
import '../resources/repository.dart';

class MoviesBloc {
  MoviesBloc();

  final _repository = Repository();

  int page = 1;
  int maxPages = 1;
  List<Movie> moviesList = new List();

  bool _hasReachedMax() => page == maxPages;

  final _moviesModelStreamController = StreamController();

  Stream get moviesModel => _moviesModelStreamController.stream;

  initState() async {
    ItemModel itemModel = await _repository.fetchAllMovies(page);
    maxPages = itemModel.total_pages;
    _moviesModelStreamController.add(itemModel.results);
  }

  Future<void> fetchMore() async {
    if (!_hasReachedMax()) {
      page++;
      fetchMovies();
    }
  }

  fetchMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies(page);
    _moviesModelStreamController.add(itemModel.results);
  }

  dispose() {
    _moviesModelStreamController.close();
  }
}
