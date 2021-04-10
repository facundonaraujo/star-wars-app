import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:star_wars_app/src/models/character_model.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends HydratedBloc<CharactersEvent, CharactersState> {
  CharactersBloc() : super(CharactersState()) {
    hydrate();
  }

  @override
  Stream<CharactersState> mapEventToState(CharactersEvent event) async* {
    if (event is ChangeCharacters) {
      yield CharactersState(charactersList: event.characters);
    }
  }

  @override
  CharactersState fromJson(Map<String, dynamic> json) =>
      CharactersState(charactersList: json['characters']);
  @override
  Map<String, List<Character>> toJson(CharactersState state) =>
      {'characters': state.characters};
}
