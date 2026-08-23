import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/splash/splash_screen.dart';
import 'localization/app_localization_delegate.dart';
import 'services/disease_classifier_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Fire-and-forget: don't await this here. If it fails, we don't want to
  // take the whole app down before runApp() even executes. Any errors are
  // caught and logged instead of crashing startup - ScanLoadingScreen already

  DiseaseClassifierService.instance.load().catchError((e, stack) {
    debugPrint("Model preload failed (will retry on first scan): $e");
  });

  runApp(const PaddyGuardApp());
}

class PaddyGuardApp extends StatefulWidget {
  const PaddyGuardApp({super.key});

  @override
  State<PaddyGuardApp> createState() => _PaddyGuardAppState();
}

class _PaddyGuardAppState extends State<PaddyGuardApp> {
  Locale _locale = const Locale('en');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: _locale,

      supportedLocales: const [Locale('en'), Locale('si')],

      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: SplashScreen(onLanguageSelected: changeLanguage),
    );
  }
}
