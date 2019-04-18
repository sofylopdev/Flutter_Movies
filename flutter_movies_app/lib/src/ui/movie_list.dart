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
 final String baseImageUrl = "https://image.tmdb.org/t/p/w185";

  @override
  void initState() {
    super.initState();
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
          title: Text("Popular Movies"),
        ),
        body: StreamBuilder(
            stream: bloc.allMovies,
            builder: (context, AsyncSnapshot<ItemModel> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot, context);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot, BuildContext cxt) {
    return StaggeredGridView.countBuilder(
      staggeredTileBuilder: (index) => new StaggeredTile.fit(1),
      itemCount: snapshot.data.results.length,
      crossAxisCount: 2,
      itemBuilder: (BuildContext context, int index) {
        ItemModel itemModel = snapshot.data;
        return GestureDetector(
          child: Image.network(
            '$baseImageUrl${itemModel.results[index].poster_path}',
            fit: BoxFit.contain,
          ),
          onTap: () {
            _goToDetails(itemModel, index);
          },
        );
      },
    );
  }

  _goToDetails(ItemModel data, int index) {
    Route route = MaterialPageRoute(
        builder: (context) => TrailersBlocProvider(
                child: MovieDetail(
              title: data.results[index].title,
              posterUrl: data.results[index].backdrop_path,
              description: data.results[index].overview,
              releaseDate: data.results[index].release_date,
              voteAverage: data.results[index].vote_average,
              movieId: data.results[index].id,
            )));

    Navigator.push(context, route);
  }
}
