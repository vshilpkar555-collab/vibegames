import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vibegames/src/features/home/data/played_game_storage.dart';
import 'package:vibegames/src/models/game_model.dart';
import 'package:vibegames/src/webview/webgame_page.dart';

class GameRankCard extends StatelessWidget {
  final GameModel gameModel;
  final int rank;

  const GameRankCard({
    super.key,
    required this.gameModel,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          /// Game Image
          InkWell(
            onTap: (){
              PlayedGameStorage.savePlayedGame(gameModel);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      WebGamePage(url: gameModel.webUrl!, title: gameModel.name),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: gameModel.thumbnail,
                height: 160,
                width: 120,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              )

              // Image.network(
              //   imageUrl,
              //   height: 160,
              //   width: 120,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          /// Big Outline Number
          Positioned(
            bottom: 0,
            left: 0,
            child: Stack(
              children: [
                Text(
                  '${rank}',
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Colors.white, // <-- Border color
                  ),
                ),
                Text(
                  "${rank}",
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // <-- Inner color
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
