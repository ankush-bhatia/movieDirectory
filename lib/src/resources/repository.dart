import 'dart:async';
import 'package:bloc/src/model/credit_model.dart';
import 'package:bloc/src/model/review_model.dart';

import 'movie_api_provider.dart';
import '../model/item_model.dart';
import '../model/trailer_model.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies(int page) {
    return movieApiProvider.fetchMovieList(page);
  }

  Future<TrailerModel> fetchTrailer(int movieId) =>
      movieApiProvider.fetchTrailer(movieId);

  Future<ReviewModel> fetchReviews(int movieId) =>
      movieApiProvider.fetchReviews(movieId);

  Future<CreditModel> fetchCredits(int movieId) =>
      movieApiProvider.fetchCredits(movieId);

  Future<ItemModel> fetchCurrentPlayingMovies() =>
      movieApiProvider.fetchCurrentPlayingMovies();
}
