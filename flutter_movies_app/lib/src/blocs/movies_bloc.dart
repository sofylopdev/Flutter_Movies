import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';

class MoviesBloc {
  final _repository = Repository();

  // PublishSubject object: adds the data which it got from the server
  // in form of ItemModel object and pass it to the UI screen as stream
  final _moviesFetcher = PublishSubject<ItemModel>();


  //To pass the ItemModel object as stream:
  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

//single instance?
final bloc = MoviesBloc();