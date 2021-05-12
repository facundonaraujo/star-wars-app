import 'dart:convert';

import 'package:star_wars_app/src/models/character_model.dart';
import 'package:star_wars_app/src/models/planet_model.dart';
import 'package:star_wars_app/src/models/starship_model.dart';
import 'package:star_wars_app/src/models/vehicle_model.dart';

CharacterDetail characterDetailFromJson(String str) =>
    CharacterDetail.fromJsonMap(json.decode(str));

String characterDetailToJson(CharacterDetail data) =>
    json.encode(data.toJson());

class CharacterDetail {
  CharacterDetail({
    this.planet,
    this.character,
    this.vehicles,
    this.startships,
  });

  Planet planet;
  Character character;
  List<Vehicle> vehicles;
  List<Starship> startships;

  factory CharacterDetail.fromJsonMap(Map<String, dynamic> json) =>
      CharacterDetail(
        planet: Planet.fromJsonMap(json["planet"]),
        character: Character.fromJsonMap(json["character"]),
        vehicles: List<Vehicle>.from(
            json["vehicles"].map((x) => Vehicle.fromJsonMap(x))),
        startships: List<Starship>.from(
            json["startships"].map((x) => Starship.fromJsonMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "planet": planet.toJson(),
        "character": character.toJson(),
        "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
        "startships": List<dynamic>.from(startships.map((x) => x.toJson())),
      };
}

class CharactersDetailsList {
  List<CharacterDetail> items = [];

  CharactersDetailsList();

  CharactersDetailsList.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final characterDetail = new CharacterDetail.fromJsonMap(item);
      items.add(characterDetail);
    }
  }
}
