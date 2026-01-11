import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:cricket_highlight/model/hive_movie_model.dart';
import 'package:cricket_highlight/model/hive_news_model.dart';
import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/provider/news_provider.dart';
import 'package:cricket_highlight/provider/saved_video_provider.dart';
import 'package:cricket_highlight/repo/NewsRepository.dart';
import 'package:cricket_highlight/service/analytics_observer.dart';
import 'package:cricket_highlight/service/app_service.dart';
import 'package:cricket_highlight/service/notification_service.dart';
import 'package:cricket_highlight/views/home/splashscreen.dart';
import 'package:cricket_highlight/views/onbording/onbording_screen.dart';
import 'package:cricket_highlight/widgets/adwidget/interstitialadwidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inappwebview_android/flutter_inappwebview_android.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_shorts/youtube_shorts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  await MobileAds.instance.initialize();

  if (Platform.isAndroid) {
    InAppWebViewPlatform.instance = AndroidInAppWebViewPlatform();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(HiveMovieModelAdapter());
  Hive.registerAdapter(NewsmodelAdapter());

  await Hive.openBox<HiveMovieModel>('saved_videos');
  await Hive.openBox<Newsmodel>('news');

  InterstitialService.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SavedVideosProvider()),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(
            repository: NewsRepository(
              apiService: ApiService(),
              newsBox: Hive.box<Newsmodel>('news'),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showOnboarding = true;

  final NotificationService _notificationService = NotificationService();

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    _notificationService.init(context);
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      await prefs.setBool('seenOnboarding', true);
      _showOnboarding = true;
    } else {
      _showOnboarding = false;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [AnalyticsObserver.observer],
      home: _showOnboarding
          ? const OnbordingScreen()
          : const Splashscreen(),
    );
  }
}
