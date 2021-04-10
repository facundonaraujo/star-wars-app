import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:star_wars_app/src/bloc/character_detail_bloc/character_detail_bloc.dart';
import 'package:star_wars_app/src/bloc/characters_bloc/characters_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';
import 'package:star_wars_app/src/pages/personajes_page.dart';
import 'package:star_wars_app/src/routes/routes.dart';
import 'package:star_wars_app/src/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => new StatusmodeBloc()),
        BlocProvider(create: (_) => new CharactersBloc()),
        BlocProvider(create: (_) => new CharacterDetailBloc()),
      ],
      child: MaterialApp(
        title: 'Star Wars App',
        debugShowCheckedModeBanner: false,
        theme: personalTheme,
        initialRoute: 'characters',
        routes: getApplicationRoutes(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => PersonajesPage());
        },
      ),
    );
  }
}
