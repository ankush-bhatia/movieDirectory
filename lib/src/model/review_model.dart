class ReviewModel {
  int page;
  int total_results;
  int total_pages;
  List<ReviewData> _results = [];

  ReviewModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['results'].length);
    page = parsedJson['page'];
    total_results = parsedJson['total_results'];
    total_pages = parsedJson['total_pages'];
    List<ReviewData> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      ReviewData result = ReviewData(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<ReviewData> get results => _results;
}

class ReviewData {
  String _id;
  String _author;
  String _content;

  ReviewData(result) {
    _id = result['id'];
    _author = result['author'];
    _content = result['content'];
  }

  String get id => _id;

  String get author => _author;

  String get content => _content;
}
