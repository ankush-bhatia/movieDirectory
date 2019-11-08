class ItemModel {
  int _page;
  int _total_results;
  int _total_pages;
  List<MovieData> _results = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['results'].length);
    _page = parsedJson['page'];
    _total_results = parsedJson['total_results'];
    _total_pages = parsedJson['total_pages'];
    List<MovieData> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      MovieData result = MovieData(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<MovieData> get results => _results;

  int get total_pages => _total_pages;

  int get total_results => _total_results;

  int get page => _page;
}

class MovieData {
  int _vote_count;
  int _id;
  bool _video;
  dynamic _vote_average;
  String _title;
  dynamic _popularity;
  String _poster_path;
  String _original_language;
  String _original_title;
  List<int> _genre_ids = [];
  String _backdrop_path;
  bool _adult;
  String _overview;
  String _release_date;

  MovieData(result) {
    _vote_count = result['vote_count'];
    _id = result['id'];
    _video = result['video'];
    _vote_average = result['vote_average'];
    _title = result['title'];
    _popularity = result['popularity'];
    _poster_path = result['poster_path'];
    _original_language = result['original_language'];
    _original_title = result['original_title'];
    for (int i = 0; i < result['genre_ids'].length; i++) {
      _genre_ids.add(result['genre_ids'][i]);
    }
    _backdrop_path = result['backdrop_path'];
    _adult = result['adult'];
    _overview = result['overview'];
    _release_date = result['release_date'];
  }

  String get release_date => _release_date;

  String get overview => _overview;

  bool get adult => _adult;

  String get backdrop_path => _backdrop_path;

  List<int> get genre_ids => _genre_ids;

  String get original_title => _original_title;

  String get original_language => _original_language;

  String get poster_path => _poster_path;

  dynamic get popularity => _popularity;

  String get title => _title;

  dynamic get vote_average => _vote_average;

  bool get video => _video;

  int get id => _id;

  int get vote_count => _vote_count;
}

class TotalItemsModel {
  List<int> _page = [];
  int _total_results;
  int _total_pages;
  List<MovieData> _results = [];

  List<int> get page => _page;

  int get total_results => _total_results;

  int get total_pages => _total_pages;

  List<MovieData> get results => _results;

  set total_pages(int value) {
    _total_pages = value;
  }

  set total_results(int value) {
    _total_results = value;
  }


}
