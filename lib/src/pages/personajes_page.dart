import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_wars_app/src/models/character_model.dart';
import 'package:star_wars_app/src/models/status_model.dart';
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
          style: TextStyle(color: Colors.white),
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
  final characterService = new CharacterService();
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
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ));
        }
      },
    );
  }
}
