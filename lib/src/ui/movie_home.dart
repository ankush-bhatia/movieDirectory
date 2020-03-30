import 'package:bloc/src/bloc/movie_home_bloc.dart';
import 'package:bloc/src/ui/movie_list.dart';
import 'package:flutter/material.dart';
import '../model/item_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
            StreamBuilder(
                stream: bloc.allMovies,
                builder: (context, AsyncSnapshot<TotalItemsModel> snapshot) {
                  if (snapshot.hasData) {
                    return buildCarousel(snapshot);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                }),
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
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = MovieHomeBloc();
    bloc.fetchCurrentPlaying();
  }

  openPopularMovieListing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieList();
      }),
    );
  }

  Widget buildCarousel(AsyncSnapshot<TotalItemsModel> snapshot) {
    return CarouselSlider.builder(
        autoPlay: true,
        enlargeCenterPage: true,
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          return Image.network(
            'https://image.tmdb.org/t/p/w500${snapshot.data.results[itemIndex].poster_path}',
            width: 400,
            fit: BoxFit.fitWidth,
          );
        });
  }
}
