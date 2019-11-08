import 'package:bloc/src/bloc/MovieHomeBloc.dart';
import 'package:bloc/src/bloc/MovieHomeBlocProvider.dart';
import 'package:bloc/src/ui/movie_list.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class MovieHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieHomeState();
  }
}

class MovieHomeState extends State<MovieHome> {
  MovieHomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MovieStore'),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Carousel(
                images: [
                  NetworkImage(
                      'https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
                  NetworkImage(
                      'https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
                ],
                indicatorBgPadding: 2,
              ),
            ),
            RaisedButton(
              onPressed: () => openPopularMovieListing(),
              child: Text(
                "See Popular Movies",
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    bloc = MovieHomeBlocProvider.of(context);
    super.didChangeDependencies();
  }

  openPopularMovieListing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieList();
      }),
    );
  }
}
