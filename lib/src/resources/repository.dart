import 'dart:async';
import 'movie_api_provider.dart';
import '../model/item_model.dart';
import '../model/trailer_model.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => movieApiProvider.fetchMovieList();

  Future<TrailerModel> fetchTrailer(int movieId) =>
      movieApiProvider.fetchTrailer(movieId);
}
