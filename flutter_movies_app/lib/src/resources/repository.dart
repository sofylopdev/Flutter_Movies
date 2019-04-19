import 'dart:async';
import 'package:flutter_movies_app/src/models/thumbs_vimeo.dart';
import 'package:flutter_movies_app/src/models/trailer_model.dart';

import 'movie_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies(int page) => moviesApiProvider.fetchMovieList(page);

  Future<TrailerModel> fetchTrailers(int movieId) => moviesApiProvider.fetchTrailers(movieId);

  Future<ThumbsVimeo> fetchThumbs(String url) => moviesApiProvider.fetchThumbs(url);
}