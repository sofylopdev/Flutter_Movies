import 'package:flutter/material.dart';
import 'package:flutter_movies_app/src/blocs/trailers_bloc_provider.dart';
import 'package:flutter_movies_app/src/ui/movie_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../blocs/movies_bloc.dart';
import '../models/item_model.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MoviesBloc bloc;
  List<Movie> moviesList;

  final String baseImageUrl = "https://image.tmdb.org/t/p/w185";
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    moviesList = new List();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = MoviesBloc();
    bloc.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Container(
            height: 30,
            width: 30,
            child: Center(child: CircularProgressIndicator())),
        //Text('Loading more...'),
        duration: Duration(milliseconds: 500),
      ));

      bloc.fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Popular Movies"),
        ),
        body: StreamBuilder(
            stream: bloc.moviesModel,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                if(moviesList.length != 0) {
                  for (Movie eachMovie in snapshot.data) {
                    if (!moviesList.contains(eachMovie)) {
                      moviesList.add(eachMovie);
                    }
                  }
                }else{
                  moviesList.addAll(snapshot.data);
                }
                return buildList(context);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Widget buildList(BuildContext cxt) {
    return StaggeredGridView.countBuilder(
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
      itemCount: moviesList.length,
      crossAxisCount: 2,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        var movie = moviesList[index];
        return GestureDetector(
          child: Image.network(
            '$baseImageUrl${movie.poster_path}',
            fit: BoxFit.contain,
          ),
          onTap: () {
            _goToDetails(movie);
          },
        );
      },
    );
  }

  _goToDetails(var movie) {
    Route route = MaterialPageRoute(
        builder: (context) => TrailersBlocProvider(
                child: MovieDetail(
              title: movie.title,
              posterUrl: movie.backdrop_path,
              description: movie.overview,
              releaseDate: movie.release_date,
              voteAverage: movie.vote_average,
              movieId: movie.id,
            )));

    Navigator.push(context, route);
  }
}
