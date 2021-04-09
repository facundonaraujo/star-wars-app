import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_wars_app/src/provider/status_model.dart';
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
    final statusProvider = Provider.of<StatusModel>(context);
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
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (statusProvider.status)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green[400],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
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
    characterService.getCharacters();
    return StreamBuilder(
      stream: characterService.charactersStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
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
  }
}
