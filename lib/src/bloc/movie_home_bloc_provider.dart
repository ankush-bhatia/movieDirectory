import 'package:bloc/src/bloc/movie_home_bloc.dart';
import 'package:flutter/cupertino.dart';

class MovieHomeBlocProvider extends InheritedWidget {
  final MovieHomeBloc bloc;

  MovieHomeBlocProvider({Key key, Widget child})
      : bloc = MovieHomeBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static MovieHomeBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType()
            as MovieHomeBlocProvider)
        .bloc;
  }
}
