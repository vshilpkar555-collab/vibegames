import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibegames/src/features/home/data/played_game_storage.dart';
import 'package:vibegames/src/features/home/presentation/home_controller.dart';
import 'package:vibegames/src/features/home/presentation/widgets/GameRankCard.dart';
import 'package:vibegames/src/features/home/presentation/widgets/HeroSliderItem.dart';
import 'package:vibegames/src/features/home/presentation/widgets/custom_appbar.dart';
import '../../../webview/webgame_page.dart';

class CategoryPage extends ConsumerStatefulWidget {
  String id;
  String catName;
  CategoryPage({super.key,required this.id,required this.catName});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  int currentSlider = 0;

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

    return homeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error: $e")),
      data: (data) {
        final gameBlock = data.games.where((g)=> widget.id==g.categoryId).toList();

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBar(
            title: "${widget.catName}",
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // POPULAR GAMES GRID
                GridView.builder(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: gameBlock.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final game = gameBlock[index];
                    return InkWell(
                      onTap: (){
                        PlayedGameStorage.savePlayedGame(game);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WebGamePage(url: game.webUrl!, title: game.name),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: game.thumbnail,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                        )

                        // Image.network(g.thumbnail, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
