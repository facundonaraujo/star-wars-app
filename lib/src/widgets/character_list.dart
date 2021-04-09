import 'package:flutter/material.dart';
import 'package:star_wars_app/src/models/character_model.dart';

class VerticalCharacterList extends StatefulWidget {
  final List<Character> characters;
  final Function nextPage;

  VerticalCharacterList({
    @required this.characters,
    @required this.nextPage,
  });

  @override
  _VerticalCharacterListState createState() => _VerticalCharacterListState();
}

class _VerticalCharacterListState extends State<VerticalCharacterList> {
  final ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _getNewCharacters();
      }
    });

    return Stack(
      children: [
        _createList(),
        _createLoading(),
      ],
    );
  }

  Widget _createLoading() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xff9792C9)),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _createList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.characters.length,
      controller: _scrollController,
      itemBuilder: (_, i) => _customButton(widget.characters[i]),
    );
  }

  Widget _customButton(Character character) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, 'characterDetail', arguments: character),
      child: Stack(
        children: <Widget>[
          _background(),
          _characterAtributesRow(character),
        ],
      ),
    );
  }

  Widget _characterAtributesRow(Character character) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 130, width: 40),
        CircleAvatar(
          radius: 26,
          child: Text(
            character.name.substring(0, 2),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff676298),
        ),
        SizedBox(width: 20),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(character.name,
                style: TextStyle(color: Colors.white, fontSize: 22)),
            SizedBox(
              height: 5,
            ),
            Text(
                'Height: ${character.height}cm, Mass: ${character.mass}kg, Gender: ${character.gender.substring(0, 1).toUpperCase() + character.gender.substring(1, character.gender.length)}',
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        )),
        Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 26,
        ),
        SizedBox(width: 40),
      ],
    );
  }

  Widget _background() {
    return Container(
        width: double.infinity,
        height: 95,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xffDC584B),
        ));
  }

  Future _getNewCharacters() async {
    _isLoading = true;
    setState(() {});
    var nextPag = await widget.nextPage();
    if (!nextPag.contains('LOADING')) {
      _isLoading = false;
      setState(() {});
      if (!nextPag.contains('ERROR')) {
        if (nextPag.length > 0) {
          _scrollController.animateTo(_scrollController.position.pixels + 100,
              duration: Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn);
        }
      }
    }
  }
}
