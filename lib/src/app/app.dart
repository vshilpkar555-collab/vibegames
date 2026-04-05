import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibegames/src/app/main.dart';
import 'package:vibegames/src/app/splash.dart';
import '../core/theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  bool isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(adServiceProvider).loadAppOpenAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(adServiceProvider).dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isFirstLaunch) {
        setState(() {
          isFirstLaunch = false;
        });
      } else {
        ref.read(adServiceProvider).showAppOpenAd();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeGames',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: SplashScreen(),
    );
  }
}
