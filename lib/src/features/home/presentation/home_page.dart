import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vibegames/src/app/main.dart';
import 'package:vibegames/src/features/home/data/played_game_storage.dart';
import 'package:vibegames/src/features/home/presentation/category_page.dart';
import 'package:vibegames/src/features/home/presentation/home_controller.dart';
import 'package:vibegames/src/features/home/presentation/widgets/GameRankCard.dart';
import 'package:vibegames/src/features/home/presentation/widgets/HeroSliderItem.dart';
import 'package:vibegames/src/services/ad_service.dart';
import '../../../webview/webgame_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentSlider = 0;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    ref.read(adServiceProvider).loadInterstitialAd();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);
    final adService = ref.watch(adServiceProvider);

    return homeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error: $e")),
      data: (data) {
        final heroBlock = data.blocks["hero_slider"]!;
        final sliderGames = data.games
            .where((g) => heroBlock.ids.contains(g.id))
            .toList();

        final categoryBlock = data.blocks["popular_categories"]!;
        final topCategories = data.categories
            .where((c) => categoryBlock.ids.contains(c.id))
            .toList();

        final popularBlock = data.blocks["popular_games"]!;
        final popularGames = data.games
            .where((g) => popularBlock.ids.contains(g.id))
            .toList();

        final playedGames = data.playedgames;

        final top10Blcok= data.blocks["top10_games"]!;
        final top10Games = data.games
            .where((g) => top10Blcok.ids.contains(g.id))
            .toList();

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HERO SLIDER
                  SizedBox(
                    height: 360,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: PageView.builder(
                            itemCount: sliderGames.length,
                            onPageChanged: (i) => setState(() => currentSlider = i),
                            itemBuilder: (context, index) {
                              final game = sliderGames[index];
                              return HeroSliderItem(game: game);
                            },
                          ),
                        ),

                        // INDICATOR DOTS
                        Positioned(
                          bottom: 5,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              sliderGames.length,
                                  (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.all(4),
                                height: 8,
                                width: currentSlider == i ? 20 : 8,
                                decoration: BoxDecoration(
                                  color: currentSlider == i
                                      ? Colors.green
                                      : Colors.white30,
                                  gradient: currentSlider == i ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF059669), // Green
                                      Color(0xFF10B981), // Emerald
                                      Color(0xFF14B8A6), // Teal
                                    ],
                                  ):null,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      itemCount: topCategories.length,
                      itemBuilder: (context, index) {
                        final c = topCategories[index];
                        final Color color = _colorFromHex(c.color);
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryPage(id: c.id,catName: c.name,),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 55,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(c.thumbnail),
                                  fit: BoxFit.cover,alignment: Alignment.center),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    colors: [
                                      color,
                                      color.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                    begin: AlignmentGeometry.bottomLeft,
                                    end: AlignmentGeometry.topRight
                                ),
                              ),
                              alignment: AlignmentGeometry.bottomLeft,
                              child: Text(
                                c.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13,fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if(playedGames.isNotEmpty) const SizedBox(height: 20),
                  // Continue played games
                 if(playedGames.isNotEmpty) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      "Continue play",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if(playedGames.isNotEmpty) const SizedBox(height: 10),

                  // games
                  if(playedGames.isNotEmpty) SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      itemCount: playedGames.length,
                      itemBuilder: (context, index) {
                        final game = playedGames[index];
                        return InkWell(
                          onTap: (){
                            PlayedGameStorage.savePlayedGame(game);
                            adService.showInterstitialAd();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WebGamePage(url: game.webUrl!, title: game.name),
                              ),
                            );
                          },
                          child: Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 15),
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      "Top 10 Games",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: top10Games.length,
                      itemBuilder: (context, index) {
                        final game = top10Games[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GameRankCard(
                            gameModel: game ,
                            rank: index + 1,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      "Popular Games",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  GridView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: popularGames.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final game = popularGames[index];
                      return InkWell(
                        onTap: (){
                          PlayedGameStorage.savePlayedGame(game);
                          adService.showInterstitialAd();
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _isBannerAdReady
              ? SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
              : null,
        );
      },
    );
  }
}
