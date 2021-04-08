import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_wars_app/src/models/character_model.dart';

class CharacterService {
  String _url = 'swapi.dev';

  int _characterPage = 1;
  bool _cargando = false;

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

  Future<List<Character>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Characters.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Character>> getCharacters() async {
    if (_cargando) return [];

    _cargando = true;

    _characterPage++;

    final url =
        Uri.https(_url, 'api/people', {'page': _characterPage.toString()});

    final resp = await _procesarRespuesta(url);

    _characters.addAll(resp);
    charactersSink(_characters);

    _cargando = false;
    return resp;
  }
}
