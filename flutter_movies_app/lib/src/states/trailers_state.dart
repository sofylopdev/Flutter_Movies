import 'package:flutter_movies_app/src/models/trailer_model.dart';

class TrailersState {
  TrailersState();

  factory TrailersState.trailerData(TrailerModel trailer) = TrailersDataState;

  factory TrailersState.loadingState() = TrailerLoadingState;

  factory TrailersState.videoImages(List<String> thumbs) =
      TrailerVideoImagesState;
}

class TrailersDataState extends TrailersState {
  final TrailerModel trailerModel;

  TrailersDataState(this.trailerModel);
}

class TrailerLoadingState extends TrailersState {}

class NoTrailerState extends TrailersState {}

class TrailerVideoImagesState extends TrailersState {
  List<String> thumbs;

  TrailerVideoImagesState(this.thumbs);
}
