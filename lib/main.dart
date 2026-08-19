import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/splash/splash_screen.dart';
import 'localization/app_localization_delegate.dart';

void main() {
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

      supportedLocales: const [
        Locale('en'),
        Locale('si'),
      ],

      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: SplashScreen(
        onLanguageSelected: changeLanguage,
      ),
    );
  }
}