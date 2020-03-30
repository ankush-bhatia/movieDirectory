import 'package:bloc/src/model/item_model.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class MovieHomeBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<TotalItemsModel>();
  final _totalItemsModel = TotalItemsModel();

  Observable<TotalItemsModel> get allMovies => _moviesFetcher.stream;

  fetchCurrentPlaying() async {
    ItemModel itemModel = await _repository.fetchCurrentPlayingMovies();
    addToTotalItems(itemModel);
    _moviesFetcher.sink.add(_totalItemsModel);
  }

  dispose() {
    _moviesFetcher.close();
  }

  void addToTotalItems(ItemModel itemModel) {
    _totalItemsModel.page.add(itemModel.page);
    _totalItemsModel.total_pages = itemModel.total_pages;
    _totalItemsModel.total_results = itemModel.page;
    _totalItemsModel.results.addAll(itemModel.results);
  }
}
