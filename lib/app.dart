import 'package:flutter/material.dart';
import 'core/store/roamli_store.dart';
import 'core/theme/roamli_theme.dart';
import 'features/splash/splash_screen.dart';

class RoamliApp extends StatefulWidget {
  const RoamliApp({super.key});
  @override
  State<RoamliApp> createState() => _RoamliAppState();
}

class _RoamliAppState extends State<RoamliApp> {
  final store = RoamliStore();
  late final Future<void> ready = store.initialize();

  @override
  Widget build(BuildContext context) => RoamliScope(
    store: store,
    child: AnimatedBuilder(
      animation: store,
      builder: (context, _) => MaterialApp(
        title: 'ROAMLI',
        debugShowCheckedModeBanner: false,
        theme: RoamliTheme.light,
        darkTheme: RoamliTheme.dark,
        themeMode: store.themeMode,
        home: FutureBuilder<void>(
          future: ready,
          builder: (context, snapshot) => SplashScreen(storeReady: snapshot.connectionState == ConnectionState.done),
        ),
      ),
    ),
  );
}
