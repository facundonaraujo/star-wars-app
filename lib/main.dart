import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:star_wars_app/src/bloc/character_detail_bloc/character_detail_bloc.dart';
import 'package:star_wars_app/src/bloc/characters_bloc/characters_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';
import 'package:star_wars_app/src/pages/personajes_page.dart';
import 'package:star_wars_app/src/routes/routes.dart';
import 'package:star_wars_app/src/theme/theme.dart';

void main() async {
  // Se inicia el storage de Hydrated Bloc
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Se establece el color de la barra de notificaciones con el color de la app
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    // Se agrega el MultiBlocProvider donde se inicializan los bloc del estado, del personaje y del personaje detalle
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
        // Se obtienen las rutas del archivo de rutas
        routes: getApplicationRoutes(),
        // En el caso de que se de algun error en alguna ruta carga un ruta por defecto que es la de PesonajesPage
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => PersonajesPage());
        },
      ),
    );
  }
}
