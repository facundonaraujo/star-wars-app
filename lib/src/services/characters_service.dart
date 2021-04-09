import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_wars_app/src/models/character_model.dart';

class CharacterService {
  String _url = 'swapi.dev';

  int _characterPage = 1;
  bool _loading = false;

  List<Character> _characters = new List();

  final _charactersStreamController =
      StreamController<List<Character>>.broadcast();

  Function(List<Character>) get charactersSink =>
      _charactersStreamController.sink.add;

  Stream<List<Character>> get charactersStream =>
      _charactersStreamController.stream;

  void disposeStream() {
    _charactersStreamController?.close();
  }

  Future<List<Character>> _processCharacters(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final charact = new CharactersList.fromJsonList(decodedData['results']);
    return charact.items;
  }

  Future<List<dynamic>> getCharacters() async {
    if (_loading) return ['LOADING'];

    _loading = true;

    _characterPage++;

    final url =
        Uri.https(_url, 'api/people', {'page': _characterPage.toString()});

    final resp = await _processCharacters(url);

    _characters.addAll(resp);
    charactersSink(_characters);

    _loading = false;
    return resp;
  }
}
