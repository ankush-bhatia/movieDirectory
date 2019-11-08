import 'package:bloc/src/bloc/MovieHomeBlocProvider.dart';
import 'package:bloc/src/ui/movie_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MovieHomeBlocProvider(
          child: MovieHome(),
        ),
      ),
    );
  }
}
