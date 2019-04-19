import 'dart:async';

import 'package:flutter_movies_app/src/models/thumbs_vimeo.dart';
import 'package:flutter_movies_app/src/models/trailer_model.dart';
import 'package:flutter_movies_app/src/resources/repository.dart';
import 'package:flutter_movies_app/src/states/trailers_state.dart';


class TrailersBloc {
  static final String YOUTUBE = "YouTube";
  static final String VIMEO = "Vimeo";
  final String baseThumbYoutubeUrl = "http://img.youtube.com/vi/";
  final String lastPathThumbYoutube = "/0.jpg";
  final String baseThumbVimeoUrl = "http://vimeo.com/api/v2/video/";
  final String lastPathThumbVimeo = ".json";

  List<String> thumbsList = new List();
  bool _hasVimeoVideo = false;
  int _totalNrTrailers = 0;

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
      _totalNrTrailers = trailersList.length;

      Future<void> delayToGetTrailers = Future.delayed(Duration(milliseconds: 200));
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
    if (site.contains(VIMEO)) {
      _hasVimeoVideo = true;
    String urlVimeoThumbList = "$baseThumbVimeoUrl$videoKey$lastPathThumbVimeo";
    Future<ThumbsVimeo> results = _repository.fetchThumbs(urlVimeoThumbList);
    results.then((thumbsValue) {
      if (thumbsValue != null) {
        thumbsList.add(thumbsValue.thumbnailMedium);
        _trailerModelStreamController.sink
            .add(TrailersState.videoImages(thumbsList));
      }
    });
  }
    if (site.contains(YOUTUBE)) {
      String linkYoutube = "$baseThumbYoutubeUrl$videoKey$lastPathThumbYoutube";
      thumbsList.add(linkYoutube);
    }

    if (!_hasVimeoVideo &&
        thumbsList.isNotEmpty &&
        (thumbsList.length > 1 || _totalNrTrailers == 1)) {
      _trailerModelStreamController.sink
          .add(TrailersState.videoImages(thumbsList));
    }

  }

  dispose() {
    _trailerModelStreamController.close();
  }

}
