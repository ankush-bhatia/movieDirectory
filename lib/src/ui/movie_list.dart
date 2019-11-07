import 'package:bloc/src/bloc/movie_detail_bloc_provider.dart';
import 'package:bloc/src/ui/movie_detail.dart';
import 'package:flutter/material.dart';
import '../model/item_model.dart';
import '../bloc/movie_bloc.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  ScrollController _controller;

  _scrollController() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      bloc.fetchAllMovies();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollController);
    bloc.fetchAllMovies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
        controller: _controller,
        itemCount: snapshot.data.results.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: 3.0,
            ),
            child: Card(
              elevation: 10.0,
              child: GridTile(
                child: InkResponse(
                  enableFeedback: true,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
                    fit: BoxFit.cover,
                  ),
                  onTap: () => openDetailPage(snapshot.data.results[index]),
                ),
              ),
            ),
          );
        });
  }

  openDetailPage(MovieData data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetailBlocProvider(
          child: MovieDetail(
            title: data.title,
            posterUrl: data.backdrop_path,
            description: data.overview,
            releaseDate: data.release_date,
            voteAverage: data.vote_average.toString(),
            movieId: data.id,
          ),
        );
      }),
    );
  }
}
