class TrailerModel {
  int _id;
  List<TrailerData> _results = [];

  TrailerModel.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    List<TrailerData> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      TrailerData result = TrailerData(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<TrailerData> get results => _results;

  int get id => _id;
}

class TrailerData {
  String _id;
  String _iso_639_1;
  String _iso_3166_1;
  String _key;
  String _name;
  String _site;
  int _size;
  String _type;
  String _poster_path;

  TrailerData(result) {
    _id = result['id'];
    _iso_639_1 = result['iso_639_1'];
    _iso_3166_1 = result['iso_3166_1'];
    _key = result['key'];
    _name = result['name'];
    _site = result['site'];
    _size = result['size'];
    _type = result['type'];
    _poster_path = result['poster_path'];
  }

  String get id => _id;

  String get iso_639_1 => _iso_639_1;

  String get iso_3166_1 => _iso_3166_1;

  String get key => _key;

  String get name => _name;

  String get site => _site;

  int get size => _size;

  String get type => _type;

  String get poster => _poster_path;
}
