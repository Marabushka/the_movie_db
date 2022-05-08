import 'package:flutter/material.dart';
import 'package:the_movie_db/app/my_app_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_movie_db/navigation/main_navigation.dart';

import 'package:the_movie_db/widgets/auth/button_styles/app_colors.dart';

class MyApp extends StatelessWidget {
  final MyAppModel model;
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key, required this.model}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(model.isAuth),
      onGenerateRoute: mainNavigation.onGenerateRoute,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.DarkBlue,
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', 'RU'),
      ],
    );
  }
}
