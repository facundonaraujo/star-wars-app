import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:star_wars_app/src/models/status_model.dart';
import 'package:star_wars_app/src/pages/personajes_page.dart';
import 'package:star_wars_app/src/routes/routes.dart';
import 'package:star_wars_app/src/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatusModel()),
      ],
      child: MaterialApp(
        title: 'Star Wars App',
        debugShowCheckedModeBanner: false,
        theme: personalTheme,
        initialRoute: 'personajes',
        routes: getApplicationRoutes(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => PersonajesPage());
        },
      ),
    );
  }
}
