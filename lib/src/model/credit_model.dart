class CreditModel {
  int _id;
  List<CastData> _cast = [];

  CreditModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['cast'].length);
    _id = parsedJson['id'];
    List<CastData> temp = [];
    for (int i = 0; i < parsedJson['cast'].length; i++) {
      CastData result = CastData(parsedJson['cast'][i]);
      temp.add(result);
    }
    _cast = temp;
  }

  List<CastData> get cast => _cast;
}

class CastData {
  String _character;
  String _name;
  String _profile_path;

  CastData(result) {
    _character = result['character'];
    _name = result['name'];
    _profile_path = result['profile_path'];
  }

  String get character => _character;

  String get name => _name;

  String get profile_path => _profile_path;
}
