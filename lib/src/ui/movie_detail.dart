import 'package:bloc/src/model/credit_model.dart';
import 'package:bloc/src/model/review_model.dart';
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
    bloc.fetchDataById(movieId);
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
                  /* title: Text(
                    title,
                  ),
                  centerTitle: false,*/
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
            Container(
              margin: EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
            ),
            Text(
              "Main Cast",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            cast(),
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            reviews(),
          ],
        ),
      ),
    );
  }

  StreamBuilder<Future<CreditModel>> cast() {
    return StreamBuilder(
      stream: bloc.movieCredits,
      builder: (context, AsyncSnapshot<Future<CreditModel>> snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: snapshot.data,
            builder: (context, AsyncSnapshot<CreditModel> itemSnapShot) {
              if (itemSnapShot.hasData) {
                return inflateCastLayout(itemSnapShot.data);
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

  StreamBuilder<Future<ReviewModel>> reviews() {
    return StreamBuilder(
      stream: bloc.movieReviews,
      builder: (context, AsyncSnapshot<Future<ReviewModel>> snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: snapshot.data,
            builder: (context, AsyncSnapshot<ReviewModel> itemSnapShot) {
              if (itemSnapShot.hasData) {
                return inflateReviewLayout(itemSnapShot.data);
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

  StreamBuilder<Future<TrailerModel>> trailers() {
    return StreamBuilder(
      stream: bloc.movieTrailers,
      builder: (context, AsyncSnapshot<Future<TrailerModel>> snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: snapshot.data,
            builder: (context, AsyncSnapshot<TrailerModel> itemSnapShot) {
              if (itemSnapShot.hasData) {
                return inflateTrailerLayout(itemSnapShot.data);
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

  Widget noTrailer() {
    return Center(
      child: Container(
        child: Text("No trailer available"),
      ),
    );
  }

  Widget noReview() {
    return Center(
      child: Container(
        child: Text("No reviews available"),
      ),
    );
  }

  Widget inflateCastLayout(CreditModel data) {
    if (data.cast.length > 0) {
      return castLayout(data.cast);
    } else {
      return noReview();
    }
  }

  Widget inflateReviewLayout(ReviewModel data) {
    if (data.results.length > 0) {
      return reviewLayout(data.results);
    } else {
      return noReview();
    }
  }

  Widget inflateTrailerLayout(TrailerModel data) {
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
      return noTrailer();
    }
  }

  Widget castLayout(List<CastData> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1 / 2,
      ),
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Card(
                  child: GridTile(
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w185${data[index].profile_path}",
                      fit: BoxFit.cover,
                      height: 180,
                    ),
                  ),
                ),
              ),
              Text(
                "${data[index].name}\nas\n${data[index].character}",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget reviewLayout(List<ReviewData> data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
              ),
              Text(
                data[index].author,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data[index].content,
              )
            ],
          ),
        );
      },
    );
  }

  Widget trailerLayout(List<TrailerData> data) {
    return Container(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
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
