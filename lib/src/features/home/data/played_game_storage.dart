import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibegames/src/features/home/domain/game.dart';
import 'package:vibegames/src/models/game_model.dart';


class PlayedGameStorage {
  static const String keyPlayedGames = "played_games";

  /// Save or update a played game
  static Future<void> savePlayedGame(GameModel game) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingList = prefs.getStringList(keyPlayedGames) ?? [];

    // Convert list to objects
    List<GameModel> games = existingList
        .map((item) => GameModel.fromJson(jsonDecode(item)))
        .toList();

    // Remove if already exists
    games.removeWhere((g) => g.id == game.id);

    // Insert updated/new game on top
    games.insert(0, game);

    // Convert back to String list
    List<String> jsonList =
    games.map((g) => jsonEncode(g.toJson())).toList();

    await prefs.setStringList(keyPlayedGames, jsonList);
  }

  /// Get all played games
  static Future<List<GameModel>> getPlayedGames() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(keyPlayedGames) ?? [];

    return jsonList
        .map((item) => GameModel.fromJson(jsonDecode(item)))
        .toList();
  }

  /// Get last played game
  static Future<GameModel?> getLastPlayedGame() async {
    final games = await getPlayedGames();
    if (games.isNotEmpty) {
      return games.first;
    }
    return null;
  }

  /// Clear all saved games
  static Future<void> clearPlayedGames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyPlayedGames);
  }
}
