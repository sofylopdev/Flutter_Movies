import 'package:flutter/material.dart';
import 'package:flutter_movies_app/src/blocs/trailers_bloc.dart';

class TrailersBlocProvider extends InheritedWidget{
  final TrailersBloc bloc;

  TrailersBlocProvider({Key key, Widget child})
  : bloc = TrailersBloc(),
  super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static TrailersBloc of(BuildContext context){
    return
      (context.inheritFromWidgetOfExactType(TrailersBlocProvider)
      as TrailersBlocProvider).bloc;
  }

}