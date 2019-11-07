import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../bloc/movie_detail_bloc_provider.dart';
import '../model/trailer_model.dart';

class MovieDetail extends StatefulWidget {
  final posterUrl;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetail({
    this.title,
    this.posterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  @override
  State<StatefulWidget> createState() {
    return MovieDetailState(
      title: title,
      posterUrl: posterUrl,
      description: description,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      movieId: movieId,
    );
  }
}

class MovieDetailState extends State<MovieDetail> {
  final posterUrl;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetailBloc bloc;

  MovieDetailState({
    this.title,
    this.posterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  @override
  void didChangeDependencies() {
    bloc = MovieDetailBlocProvider.of(context);
    bloc.fetchTrailersById(movieId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    title,
                  ),
                  centerTitle: false,
                  background: Image.network(
                    "https://image.tmdb.org/t/p/w500$posterUrl",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: detailsLayout(),
        ),
      ),
    );
  }

  Widget detailsLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 5.0)),
            Text(
              title,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Row(
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                Container(
                  margin: EdgeInsets.only(left: 1.0, right: 1.0),
                ),
                Text(
                  voteAverage,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(
                  releaseDate,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Text(description),
            Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Text(
              "Trailer",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
            ),
            trailers(),
          ],
        ),
      ),
    );
  }

  StreamBuilder<Future<TrailerModel>> trailers() {
    return StreamBuilder(
      stream: bloc.movieTrailers,
      builder: (context, AsyncSnapshot<Future<TrailerModel>> snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: snapshot.data,
            builder: (context, AsyncSnapshot<TrailerModel> itemSnapShot) {
              if (itemSnapShot.hasData) {
                return inflateLayout(itemSnapShot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget noTrailer(TrailerModel data) {
    return Center(
      child: Container(
        child: Text("No trailer available"),
      ),
    );
  }

  Widget inflateLayout(TrailerModel data) {
    List<TrailerData> trailerData = List<TrailerData>();

    if (data.results.length > 0) {
      for (int i = 0; i < data.results.length; i++) {
        if (data.results[i].type.toLowerCase() == "trailer") {
          trailerData.add(data.results[i]);
        }
      }
    }

    if (trailerData.length > 0) {
      return trailerLayout(trailerData);
    } else {
      return noTrailer(data);
    }
  }

  Widget trailerLayout(List<TrailerData> data) {
    return Container(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => openYoutube(data[index].key),
            child: Container(
              width: 200.0,
              padding: EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 3.0,
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5.0),
                        height: 100.0,
                        width: 200.0,
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w200$posterUrl",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        height: 100.0,
                        width: 200.0,
                        color: Colors.grey.withAlpha(100),
                        child: Center(
                          child: Icon(Icons.play_circle_filled),
                        ),
                      )
                    ],
                  ),
                  Text(
                    data[index].name,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  openYoutube(String key) async {
    String url = "https://www.youtube.com/watch?v=$key";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
