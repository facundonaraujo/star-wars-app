import 'package:flutter/material.dart';
import 'package:star_wars_app/src/models/character_model.dart';

class VerticalCharacterList extends StatelessWidget {
  final List<Character> characters;
  final Function nextPage;

  const VerticalCharacterList({
    @required this.characters,
    @required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
              return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: characters.length,
            separatorBuilder: (_, i) => Divider(
              color: Colors.blue,
            ),
            itemBuilder: (_, i) => ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(characters[i].name),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
          );
  }
}
