import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_wars_app/src/bloc/characters_bloc/characters_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';
import 'package:star_wars_app/src/models/character_model.dart';
import 'package:star_wars_app/src/services/search_service.dart';
import 'package:star_wars_app/src/widgets/character_list.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  DataSearch({
    String hintText = "Search Character",
  }) : super(
          searchFieldLabel: hintText,
          searchFieldStyle: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar (Como un icono para cancelar la busqueda)
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: Color(0xff232042),
      primaryColor: Color(0xff232042),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
      ),
      textTheme: TextTheme(
        headline5: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar (icono para regresar)
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final CharacterSearchService characterSearchService =
        new CharacterSearchService();
    // Crea los resultados que vamos a mostrar
    return _createSearch(characterSearchService);
  }

  Widget _createSearch(CharacterSearchService characterSearchService) {
    return BlocBuilder<StatusmodeBloc, StatusmodeState>(
        builder: (context, state) {
      var status = (state.statusMode != null) ? state.statusMode : false;
      // Se comprueba cual es estado de la app
      if (status == true) {
        // Si esta en el modo online se hace la busqueda al characterSearchService
        // Cada vez que se realiza una nueva busqueda se vacia el stream y se setea la pagina inicial en 0
        List<Character> charactersSearch = [];
        characterSearchService.characterPage = 0;
        characterSearchService.charactersSearchSink(charactersSearch);
        characterSearchService.getCharactersSearch(query);
        return Container(
          color: Color(0xff232042),
          child: StreamBuilder(
            stream: characterSearchService.charactersSearchStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                // En el caso que se devuelta una lista vacia, es decir que no se encontro ningun personaje que coincida con
                // la busqueda, se muestra un mensaje
                if (snapshot.data.length == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 80,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                          child: Text(
                        'Search not found',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                } else {
                  final List<Character> characterList = snapshot.data;
                  // En el caso de que si encuentre la busqueda se dibuja la lista
                  return VerticalCharacterList(
                    characters: characterList,
                    nextPage: characterSearchService.getCharactersSearch,
                    isSearch: true,
                    query: query,
                  );
                }
              } else {
                // Mientras se hace la consulta se muestra una animacion del logo de star wars
                return Center(
                    child: Pulse(
                  infinite: true,
                  duration: Duration(milliseconds: 1500),
                  child: Image(
                    image: AssetImage('assets/star-wars-logo.png'),
                    height: 100,
                  ),
                ));
              }
            },
          ),
        );
      } else {
        // En el caso que este en el modo offline
        return Container(
          color: Color(0xff232042),
          child: BlocBuilder<CharactersBloc, CharactersState>(
            builder: (context, state) {
              // Se comprueba que la consulta ingreada coicida con los nombres de los personajes que hay en la lista del bloc
              // En el caso de que coicidan se muestra las lista de personajes cuyo nombre coincide con la busqueda
              // En el caso de que no coincida ninguno se muestra un mensaje
              if (state.characters != null && state.characters.length > 0) {
                List<Character> charactersSearch = [];
                for (Character character in state.characters) {
                  if (character.name
                      .toLowerCase()
                      .contains(query.toLowerCase())) {
                    charactersSearch.add(character);
                  }
                }
                if (charactersSearch.length > 0) {
                  return VerticalCharacterList(
                    characters: charactersSearch,
                    nextPage: characterSearchService.getCharactersSearch,
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 80,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                          child: Text(
                        'Search not found',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                }
              } else {
                // En el caso de que no hayan elementos en la lista se muestra un mensaje
                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 80,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                        child: Text(
                      'There is no information to display',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'If it is your first time in the app',
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Karla'),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Make sure you are connected to the internet or in Online mode',
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Karla'),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        );
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container(
        color: Color(0xff232042),
      );
    }
    final CharacterSearchService characterSearchService =
        new CharacterSearchService();
    return _createSearch(characterSearchService);
  }
}
