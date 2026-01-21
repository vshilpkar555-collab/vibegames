import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/game.dart';

class LocalGamesDataSource {
  Future<List<Game>> loadGames() async {
    final jsonStr = await rootBundle.loadString('assets/games.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    return list.map((e) => Game.fromJson(e as Map<String, dynamic>)).toList();
  }
}
