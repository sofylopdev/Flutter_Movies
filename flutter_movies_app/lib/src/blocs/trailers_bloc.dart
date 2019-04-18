import 'dart:async';

import 'package:flutter_movies_app/src/models/thumbs_vimeo.dart';
import 'package:flutter_movies_app/src/models/trailer_model.dart';
import 'package:flutter_movies_app/src/resources/repository.dart';

class TrailersState {
  TrailersState();

  factory TrailersState.trailerData(TrailerModel trailer) = TrailersDataState;

  factory TrailersState.loadingState() = TrailerLoadingState;

  factory TrailersState.videoImages(String thumbs) = TrailerVideoImagesState;
}

class TrailersDataState extends TrailersState {
  final TrailerModel trailerModel;
  TrailersDataState(this.trailerModel);
}

class TrailerLoadingState extends TrailersState {}

class NoTrailerState extends TrailersState {}

class TrailerVideoImagesState extends TrailersState {
  final String thumbs;

  TrailerVideoImagesState(this.thumbs);
}

class TrailersBloc {
  static final String YOUTUBE = "YouTube";
  static final String VIMEO = "Vimeo";
  final String baseThumbYoutubeUrl = "http://img.youtube.com/vi/";
  final String lastPathThumbYoutube = "/0.jpg";
  final String baseThumbVimeoUrl = "http://vimeo.com/api/v2/video/";
  final String lastPathThumbVimeo = ".json";

  TrailersBloc();

  final _repository = Repository();

  final _trailerModelStreamController = StreamController<TrailersState>();

  Stream<TrailersState> get trailerModel =>
      _trailerModelStreamController.stream;

  void loadTrailerModel(int movieId) async {
    _trailerModelStreamController.sink.add(TrailersState.loadingState());

    _repository.fetchTrailers(movieId).then((trailer) {
      _trailerModelStreamController.sink.add(TrailersState.trailerData(trailer));

      List<EachTrailer> trailersList = trailer.results;

      Future<void> delayToGetTrailers = Future.delayed(Duration(seconds:1));
      delayToGetTrailers.then((voids){

        for (EachTrailer trailer in trailersList) {
        String site = trailer.site;
        String videoKey = trailer.key;

        if (site.contains(YOUTUBE) || (site.contains(VIMEO))) {
          buildVideoImage(site, videoKey);
        }
      }});
    });
  }

  void buildVideoImage(String site, String videoKey) {
    if (site.contains(YOUTUBE)) {
      String linkYoutube = "$baseThumbYoutubeUrl$videoKey$lastPathThumbYoutube";
      _trailerModelStreamController.sink
          .add(TrailersState.videoImages(linkYoutube));
    }
    if (site.contains(VIMEO)) {
      String urlVimeoThumbList = "$baseThumbVimeoUrl$videoKey$lastPathThumbVimeo";
      Future<ThumbsVimeo> results = _repository.fetchThumbs(urlVimeoThumbList);
      results.then((thumbsValue) {
        if (thumbsValue != null) {
          _trailerModelStreamController.sink
              .add(TrailersState.videoImages(thumbsValue.thumbnailMedium));
        }
      });
    }
  }

  dispose() {
    _trailerModelStreamController.close();
  }

}
