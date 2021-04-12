import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_wars_app/src/models/character_model.dart';

class CharacterSearchService {
  String _url = 'swapi.dev';
  int characterPage = 0;
  bool _loading = false;
  List<Character> _charactersSearch = new List();

  final _charactersSearchStreamController =
      StreamController<List<Character>>.broadcast();

  Function(List<Character>) get charactersSearchSink =>
      _charactersSearchStreamController.sink.add;

  Stream<List<Character>> get charactersSearchStream =>
      _charactersSearchStreamController.stream;

  void disposeStream() {
    _charactersSearchStreamController?.close();
  }

  Future<List<Character>> _processCharacters(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final charact = new CharactersList.fromJsonList(decodedData['results']);
    return charact.items;
  }

  Future<List<dynamic>> getCharactersSearch(String query) async {
    // Se intenta obtener los personajes
    try {
      if (_loading) return ['LOADING'];
      // se avisa que esta cargando informacion para que en el widget de la lista se muestre el loading
      _loading = true;
      // Se aumenta el numero de pagina
      characterPage++;

      final url = Uri.https(_url, 'api/people', {
        'search': query,
        'page': characterPage.toString(),
      });
      // Se hace la consulta y se obtiene la respuesta decodificada y mapeada en un arreglo de personajes
      final resp = await _processCharacters(url);
      // Se añade la respuesta al arreglo de personajes, asi se conservan los datos cargados previamente y se va aumentando la lista
      // Y se la añade al stream asi los oyentes del stream obtienen la lista actualizada
      _charactersSearch.addAll(resp);
      charactersSearchSink(_charactersSearch);
      // se avisa que la informacion ya se cargo para que en el widget de la lista deje de mostrar el loading
      _loading = false;
      return resp;
    } catch (e) {
      // En el caso de que se produzca un error al obtener los personajes
      // Se devuelve una lista vacia al stream
      // Y devuelve un error
      List<Character> _charactersSearchEmpty = new List();
      charactersSearchSink(_charactersSearchEmpty);
      return ['ERROR'];
    }
  }
}
