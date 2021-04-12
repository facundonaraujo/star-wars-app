import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_wars_app/src/bloc/characters_bloc/characters_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';
import 'package:star_wars_app/src/models/character_model.dart';
import 'package:star_wars_app/src/services/characters_service.dart';
import 'package:star_wars_app/src/widgets/character_list.dart';
import 'package:star_wars_app/src/widgets/lateral_menu.dart';

class PersonajesPage extends StatefulWidget {
  @override
  _PersonajesPageState createState() => _PersonajesPageState();
}

class _PersonajesPageState extends State<PersonajesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          'Star Wars',
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        elevation: 1,
        backgroundColor: Color(0xff232042),
        actions: [
          // Se consulta en cual modo esta la app
          BlocBuilder<StatusmodeBloc, StatusmodeState>(
            builder: (context, state) {
              var status =
                  (state.statusMode != null) ? state.statusMode : false;
              return Container(
                margin: EdgeInsets.only(right: 10),
                child: (status)
                    // Dependiendo del modo en el que este se elige un icono u otro.
                    // Sirven para mostrar visualmente en que estado esta la app
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green[400],
                      )
                    : Icon(
                        Icons.offline_bolt,
                        color: Colors.red,
                      ),
              );
            },
          ),
        ],
      ),
      // Se crea el menu lateral donde se puede cambiar el modo de la app
      drawer: LateralMenu(),
      // Se crea la lista de personajes
      body: _CharacterList(),
    );
  }
}

class _CharacterList extends StatelessWidget {
  final CharacterService characterService = new CharacterService();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusmodeBloc, StatusmodeState>(
      builder: (context, state) {
        var status = (state.statusMode != null) ? state.statusMode : false;
        // Se comprueba cual es estado de la app
        if (status == true) {
          // Si esta en modo online se obtienen los personajes a traves del servicio
          characterService.getCharacters();
          return StreamBuilder(
            stream: characterService.charactersStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // En el caso que se devuelta una lista vacia se muestra un mensaje
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
                        'There is no information to display',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                      SizedBox(
                        height: 15,
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
                } else {
                  // En el caso de que venga algun item en la lista se añade la lista al bloc
                  final List<Character> characterList = snapshot.data;
                  if (characterList != null && characterList.length > 0) {
                    BlocProvider.of<CharactersBloc>(context)
                        .add(ChangeCharacters(characterList));
                  }
                  // Se dibuja la lista
                  return VerticalCharacterList(
                    characters: characterList,
                    nextPage: characterService.getCharacters,
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
          );
        } else {
          // En el caso de que este en el modo offline se comprueba el bloc de character
          // Donde devuelve los personajes guardados en el modo online
          return BlocBuilder<CharactersBloc, CharactersState>(
            builder: (context, state) {
              // Si hay personajes en el bloc se dibuja la lista
              if (state.characters != null) {
                return VerticalCharacterList(
                  characters: state.characters,
                  nextPage: characterService.getCharacters,
                );
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
                        text:
                            'Make sure you are connected to the internet or in Online mode',
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Karla'),
                      ),
                    )
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
