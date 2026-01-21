import 'dart:convert';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:vibegames/src/features/home/data/played_game_storage.dart';
import '../../../models/category_model.dart';
import '../../../models/game_model.dart';
import '../../../models/blocks_model.dart';

class HomeDataSource {
  Future<Map<String, dynamic>> loadJSON() async {
    final raw = await rootBundle.loadString('assets/games.json');
    return json.decode(raw);
  }

  Future<List<CategoryModel>> loadCategories(Map<String, dynamic> json) async {
    return (json["categories"] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  Future<List<GameModel>> loadGames(Map<String, dynamic> json) async {
    return (json["games"] as List)
        .map((e) => GameModel.fromJson(e))
        .toList();
  }
  Future<List<GameModel>> loadPlayedGames(Map<String, dynamic> json) async {
    List<GameModel> games = await PlayedGameStorage.getPlayedGames();
    return games;
  }

  Future<Map<String, BlockModel>> loadBlocks(Map<String, dynamic> json) async {
    final map = <String, BlockModel>{};
    json["blocks"].forEach((key, value) {
      map[key] = BlockModel.fromJson(value);
    });
    return map;
  }





}
