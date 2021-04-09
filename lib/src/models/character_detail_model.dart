import 'package:star_wars_app/src/models/planet_model.dart';
import 'package:star_wars_app/src/models/starship_model.dart';
import 'package:star_wars_app/src/models/vehicle_model.dart';

class CharacterDetail {
  CharacterDetail({
    this.planet,
    this.vehicles,
    this.startships,
  });

  Planet planet;
  List<Vehicle> vehicles;
  List<Starship> startships;
}
