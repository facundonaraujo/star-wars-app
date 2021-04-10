import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_wars_app/src/bloc/characters_bloc/characters_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';
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
          BlocBuilder<StatusmodeBloc, StatusmodeState>(
            builder: (context, state) {
              var status =
                  (state.statusMode != null) ? state.statusMode : false;
              return Container(
                margin: EdgeInsets.only(right: 10),
                child: (status)
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
      drawer: LateralMenu(),
      body: _CharacterList(),
    );
  }
}

class _CharacterList extends StatelessWidget {
  final CharacterService characterService = new CharacterService();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusmodeBloc, StatusmodeState>(
      // ignore: missing_return
      builder: (context, state) {
        var status = (state.statusMode != null) ? state.statusMode : false;
        if (status) {
          characterService.getCharacters();
          return StreamBuilder(
            stream: characterService.charactersStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
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
                }
                if (snapshot.data.length > 0) {
                  BlocProvider.of<CharactersBloc>(context)
                      .add(ChangeCharacters(snapshot.data));
                }
                return VerticalCharacterList(
                  characters: snapshot.data,
                  nextPage: characterService.getCharacters,
                );
              } else {
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
          BlocBuilder<CharactersBloc, CharactersState>(
            builder: (context, state) {
              return VerticalCharacterList(
                characters: state.characters,
                nextPage: characterService.getCharacters,
              );
            },
          );
        }
      },
    );
  }
}
