import 'package:bloc/src/model/item_model.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class MovieBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  fetchAllMovies(int page) async {
    ItemModel itemModel = await _repository.fetchAllMovies(page);
    _moviesFetcher.sink.add(itemModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = MovieBloc();
