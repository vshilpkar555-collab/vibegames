import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vibegames/src/features/home/data/played_game_storage.dart';
import 'package:vibegames/src/models/game_model.dart';
import 'package:vibegames/src/webview/webgame_page.dart';
import 'package:video_player/video_player.dart';

class HeroSliderItem extends StatefulWidget {
  final GameModel game;
  const HeroSliderItem({required this.game, super.key});

  @override
  State<HeroSliderItem> createState() => _HeroSliderItemState();
}

class _HeroSliderItemState extends State<HeroSliderItem> {
  VideoPlayerController? _controller;
  bool videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final url = widget.game.videoUrl;

    if (url == null || url.isEmpty) {
      setState(() => videoFailed = true);
      return;
    }

    try {
      if (url.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        _controller = VideoPlayerController.asset(url);
      }

      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.play();

      if (mounted) setState(() {});
    } catch (e) {
      setState(() => videoFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;

    return Stack(
      children: [
        // ============================
        // VIDEO (if works) or IMAGE
        // ============================
        if (!videoFailed &&
            _controller != null &&
            _controller!.value.isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          )
        else

          CachedNetworkImage(
            imageUrl: game.thumbnail,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),

        // ============================
        // DARK GRADIENT OVERLAY
        // ============================
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // ============================
        // TITLE, TAGS & PLAY BUTTON
        // ============================
        Positioned(
          left: 20,
          right: 20,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TITLE
              Text(
                game.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 6),

              // TAGS (hashtags joined)
              Text(
                game.hashtags.join(" • "),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 15),

              // PLAY BUTTON
              InkWell(
                onTap: () {
                  if (game.type == "web" && game.webUrl != null) {
                    PlayedGameStorage.savePlayedGame(game);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            WebGamePage(url: game.webUrl!, title: game.name),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // color: Colors.green,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF059669), // Green
                        Color(0xFF10B981), // Emerald
                        Color(0xFF14B8A6), // Teal
                      ],
                    ),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Text(
                    "Play Now",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
