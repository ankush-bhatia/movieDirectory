import 'dart:async';

import 'package:bloc/src/model/credit_model.dart';
import 'package:bloc/src/model/review_model.dart';
import 'package:bloc/src/model/trailer_model.dart';
import 'package:rxdart/rxdart.dart';
import '../model/trailer_model.dart';
import '../resources/repository.dart';

class MovieDetailBloc {
  final _repository = Repository();
  final _movieId = PublishSubject<int>();
  final _trailers = BehaviorSubject<Future<TrailerModel>>();
  final _reviews = BehaviorSubject<Future<ReviewModel>>();
  final _credits = BehaviorSubject<Future<CreditModel>>();

  Function(int) get fetchDataById => _movieId.sink.add;

  Observable<Future<TrailerModel>> get movieTrailers => _trailers.stream;

  Observable<Future<ReviewModel>> get movieReviews => _reviews.stream;

  Observable<Future<CreditModel>> get movieCredits => _credits.stream;

  MovieDetailBloc() {
    _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
    _movieId.stream.transform(_reviewTransformer()).pipe(_reviews);
    _movieId.stream.transform(_creditTransformer()).pipe(_credits);
  }

  dispose() async {
    _movieId.close();
    await _trailers.drain();
    await _reviews.drain();
    await _credits.drain();
    _trailers.close();
    _reviews.close();
    _credits.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Future<TrailerModel> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchTrailer(id);
        return trailer;
      },
    );
  }

  _reviewTransformer() {
    return ScanStreamTransformer(
      (Future<ReviewModel> review, int id, int index) {
        print(index);
        review = _repository.fetchReviews(id);
        return review;
      },
    );
  }

  _creditTransformer() {
    return ScanStreamTransformer(
      (Future<CreditModel> credit, int id, int index) {
        print(index);
        credit = _repository.fetchCredits(id);
        return credit;
      },
    );
  }
}
