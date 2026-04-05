import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/home_data_source.dart';
import '../../../models/category_model.dart';
import '../../../models/game_model.dart';
import '../../../models/blocks_model.dart';

final homeControllerProvider =
StateNotifierProvider<HomeController, AsyncValue<HomeState>>((ref) {
  return HomeController(HomeDataSource());
});

class HomeState {
  final List<CategoryModel> categories;
  final List<GameModel> games;
  final List<GameModel> playedgames;
  final Map<String, BlockModel> blocks;

  const HomeState({
    required this.categories,
    required this.games,
    required this.playedgames,
    required this.blocks,
  });
}

class HomeController extends StateNotifier<AsyncValue<HomeState>> {
  final HomeDataSource dataSource;

  HomeController(this.dataSource) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await dataSource.loadJSON();
      final cats = await dataSource.loadCategories(json);
      final games = await dataSource.loadGames(json);
      final blocks = await dataSource.loadBlocks(json);
      final playedGame = await dataSource.loadPlayedGames(json);

      state = AsyncValue.data(
        HomeState(categories: cats, games: games, blocks: blocks,playedgames: playedGame),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
