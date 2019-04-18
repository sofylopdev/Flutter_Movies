import 'dart:async';
import 'package:flutter_movies_app/src/models/thumbs_vimeo.dart';
import 'package:flutter_movies_app/src/models/trailer_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';

class MovieApiProvider {
  Client client = Client();

  //todo: put your api key here:
  final _apiKey = 'put_your_api_key_here';
  
  final _baseUrl = "http://api.themoviedb.org/3/movie";
  //final _youtubeBaseUrl = "https://www.youtube.com/watch?v=";

  Future<ItemModel> fetchMovieList() async {
    final response = await client
        .get("$_baseUrl/popular?api_key=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<TrailerModel> fetchTrailers(int movieId) async {
    final response = await client.get(
        "$_baseUrl/$movieId/videos?api_key=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load videos');
    }
  }

  Future<ThumbsVimeo> fetchThumbs(String url) async {
    final response = await client.get(url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> list = json.decode(response.body);
      return ThumbsVimeo.fromJson(list[0]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load thumbs');
    }
  }
}