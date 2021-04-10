import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_wars_app/src/models/character_detail_model.dart';
import 'package:star_wars_app/src/models/character_model.dart';
import 'package:star_wars_app/src/models/planet_model.dart';
import 'package:star_wars_app/src/models/starship_model.dart';
import 'package:star_wars_app/src/models/vehicle_model.dart';

class CharacterDetailService {
  List<Vehicle> _vehicles = new List();
  List<Starship> _startships = new List();

  Future<Starship> _processStarships(String url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final startship = new Starship.fromJsonMap(decodedData);
    return startship;
  }

  Future<Vehicle> _processVehicles(String url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final vehicle = new Vehicle.fromJsonMap(decodedData);
    return vehicle;
  }

  Future<Planet> _processPlanet(String url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final planet = new Planet.fromJsonMap(decodedData);
    return planet;
  }

  Future getCharacterDetails(Character character) async {
    try {
      var respPlanet;

      if (character.homeworld != null && character.homeworld != '') {
        final urlPlanet = character.homeworld;
        respPlanet = await _processPlanet(urlPlanet);
      }

      if (character.vehicles != null && character.vehicles.length > 0) {
        for (var i = 0; i < character.vehicles.length; i++) {
          final urlvehicles = character.vehicles[i];
          final respVehicles = await _processVehicles(urlvehicles);
          _vehicles.add(respVehicles);
        }
      }

      if (character.starships != null && character.starships.length > 0) {
        for (var i = 0; i < character.starships.length; i++) {
          final urlStarships = character.starships[i];
          final respStarships = await _processStarships(urlStarships);
          _startships.add(respStarships);
        }
      }

      final CharacterDetail resp = new CharacterDetail(
          planet: respPlanet,
          startships: _startships,
          vehicles: _vehicles,
          character: character);

      return resp;
    } catch (e) {
      final Planet errPlanet = new Planet(name: 'Unknown');
      final List<Vehicle> errVehicles = new List();
      final List<Starship> errstartships = new List();
      final CharacterDetail resp = new CharacterDetail(
          planet: errPlanet,
          startships: errstartships,
          vehicles: errVehicles,
          character: character);
      return resp;
    }
  }
}
