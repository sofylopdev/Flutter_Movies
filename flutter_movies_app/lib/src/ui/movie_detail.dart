import 'package:flutter/material.dart';
import 'package:flutter_movies_app/src/blocs/trailers_bloc.dart';
import 'package:flutter_movies_app/src/blocs/trailers_bloc_provider.dart';
import 'package:flutter_movies_app/src/models/trailer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final posterUrl;
  final description;
  final releaseDate;
  final String title;
  final voteAverage;
  final movieId;

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
  final voteAverage;
  final movieId;

  MovieDetailState({
    this.title,
    this.posterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  TrailersBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = TrailersBlocProvider.of(context);
    bloc.loadTrailerModel(movieId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  List<String> trailerUrls = new List();
  TrailerModel trailerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context,
                  bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                          buildImageUrl(), fit: BoxFit.cover),
                    ),
                  )
                ];
              },
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        title,
                        style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 1.0, left: 1.0),
                              child: Text(
                                "$voteAverage",
                                style: TextStyle(fontSize: 18.0),
                              )),
                          Container(
                            margin: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Text(
                              releaseDate,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        description,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        "Trailer",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    StreamBuilder(
                      stream: bloc.trailerModel,
                      builder: (context,
                          AsyncSnapshot<TrailersState> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data is TrailerLoadingState) {
                            return loading();
                          }
                          if (snapshot.data is TrailersDataState) {
                            TrailersDataState state = snapshot.data;
                            trailerModel = state.trailerModel;
                            if (trailerModel.results.length > 0)
                              return loading();
                            else
                              return noTrailer();
                          }
                          if (snapshot.data is TrailerVideoImagesState) {
                            TrailerVideoImagesState state = snapshot.data;
                            String imageUrl = state.thumbs;
                            trailerUrls.add(imageUrl);
                            return trailerLayout(trailerModel, trailerUrls);
                          } else {
                            return hasError();
                          }
                        } else {
                          return hasError();
                        }
                      },
                    )
                  ],
                ),
              )),
        ));
  }

  Widget noTrailer() {
    return Center(child: Text("No trailers available."));
  }

  Widget hasError() {
    return Center(child: Text("Something happened. Please try again."));
  }

  Widget trailerLayout(TrailerModel data, List<String> urlList) {
    if (urlList.length > 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          trailerItem(data, 0, urlList.elementAt(0)),
          trailerItem(data, 1, urlList.elementAt(1)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          trailerItem(data, 0, urlList.elementAt(0)),
        ],
      );
    }
  }

  trailerItem(TrailerModel data, int index, String url) {
    String trailerTitle = "";
    if (data != null) {
      trailerTitle = data.results[index].name;
    } else {
      print("Data is NULL");
    }
    return Expanded(
      child: GestureDetector(
        onTap: () {
          try {
            _launchURL(data, index);
          } catch (e) {
            print("Couldn't launch video.");
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getImageForVideo(url),
            Container(
              width: 200,
              child: Text(
                trailerTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget getImageForVideo(String url) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.all(5.0),
        height: 100.0,
        child: Image.network(url));
  }

  String buildImageUrl() {
    return "https://image.tmdb.org/t/p/w500$posterUrl";
  }

  String buildYoutubeUrl(String videoKey) {
    return "https://www.youtube.com/watch?v=$videoKey";
  }

  String buildVimeoUrl(String videoKey) {
    return "https://vimeo.com/$videoKey";
  }

  _launchURL(TrailerModel data, int index) async {
    String site = data.results[index].site;
    if (site.contains(TrailersBloc.YOUTUBE)) {
      String videoKey = data.results[index].key;
      final url = buildYoutubeUrl(videoKey);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (site.contains(TrailersBloc.VIMEO)) {
      String videoKey = data.results[index].key;
      final url = buildVimeoUrl(videoKey);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
