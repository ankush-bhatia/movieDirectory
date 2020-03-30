import 'dart:async';
import 'dart:math';
import 'package:bloc/src/model/credit_model.dart';
import 'package:bloc/src/model/review_model.dart';
import 'package:bloc/src/model/trailer_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../model/item_model.dart';

class MovieApiProvider {
  Client client = Client();
  final _apiKey = 'a7f1243431540ff546e5ccebe0415843';
  final _baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchMovieList(int page) async {
    final response =
        await client.get("$_baseUrl/popular?api_key=$_apiKey&page=$page");

    print(response.body.toString());

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load post");
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    final response =
        await client.get("$_baseUrl/$movieId/videos?api_key=$_apiKey");

    print(response.body.toString());

    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Filed to load trailers");
    }
  }

  Future<ReviewModel> fetchReviews(int movieId) async {
    final response =
        await client.get("$_baseUrl/$movieId/reviews?api_key=$_apiKey");

    print(response.body.toString());

    if (response.statusCode == 200) {
      return ReviewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Filed to load reviews");
    }
  }

  Future<CreditModel> fetchCredits(int movieId) async {
    final response =
        await client.get("$_baseUrl/$movieId/credits?api_key=$_apiKey");

    print(response.body.toString());

    if (response.statusCode == 200) {
      return CreditModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Filed to load credits");
    }
  }

  Future<ItemModel> fetchCurrentPlayingMovies() async {
    final response = await client.get("$_baseUrl/now_playing?api_key=$_apiKey");

    print(response.body.toString());

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Filed to load popular images");
    }
  }
}
