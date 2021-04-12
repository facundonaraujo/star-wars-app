import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_wars_app/src/models/character_model.dart';

class CharacterService {
  String _url = 'swapi.dev';
  int _characterPage = 1;
  bool _loading = false;
  List<Character> _characters = new List();

  // Se crean las varaibles del stream
  // Se utiliza streams por que la informacion va cambiando y se desea guardar la informacion ya obtenida y sumarle la nueva
  // Asi cuando se oye el stream(Stream Builder) se va a redibujar añadiendo la informacion nueva y conservando la anterior
  // Y asi cuando se cargan los nuevos 10 personajes no se vuelve al principio de la lista sino que se queda en la posicion
  // en donde estaba y aparece abajo los nuevos elementos
  // No se utiliza Future Builder por el hecho de que si se cambia la informacion no se redibuja el widget en cambio con el stream builder si
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
    // Se intenta obtener los personajes
    try {
      if (_loading) return ['LOADING'];
      // se avisa que esta cargando informacion para que en el widget de la lista se muestre el loading
      _loading = true;
      // Se aumenta el numero de pagina
      _characterPage++;

      final url =
          Uri.https(_url, 'api/people', {'page': _characterPage.toString()});
      // Se hace la consulta y se obtiene la respuesta decodificada y mapeada en un arreglo de personajes
      final resp = await _processCharacters(url);
      // Se añade la respuesta al arreglo de personajes, asi se conservan los datos cargados previamente y se va aumentando la lista
      // Y se la añade al stream asi los oyentes del stream obtienen la lista actualizada
      _characters.addAll(resp);
      charactersSink(_characters);
      // se avisa que la informacion ya se cargo para que en el widget de la lista deje de mostrar el loading
      _loading = false;
      return resp;
    } catch (e) {
      // En el caso de que se produzca un error al obtener los personajes
      // Se devuelve una lista vacia al stream
      // Y devuelve un error
      List<Character> _charactersEmpty = new List();
      charactersSink(_charactersEmpty);
      return ['ERROR'];
    }
  }
}
