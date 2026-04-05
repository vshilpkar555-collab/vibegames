import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;
  const GameCard({required this.game, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final thumb = game.thumbnail;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: thumb != null && thumb.startsWith('http')
                  ? CachedNetworkImage(
                imageUrl: thumb,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (c, s) => const Center(child: CircularProgressIndicator()),
                errorWidget: (c, s, e) => const Icon(Icons.videogame_asset),
              )
                  : (thumb != null
                  ? Image.asset(thumb, fit: BoxFit.cover, width: double.infinity)
                  : const Icon(Icons.videogame_asset, size: 56)),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(game.title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            // ),
          ],
        ),
      ),
    );
  }
}
