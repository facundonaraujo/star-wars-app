import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:star_wars_app/src/models/character_detail_model.dart';

part 'character_detail_event.dart';
part 'character_detail_state.dart';

class CharacterDetailBloc
    extends HydratedBloc<CharacterDetailEvent, CharacterDetailState> {
  CharacterDetailBloc() : super(CharacterDetailState()) {
    hydrate();
  }

  @override
  Stream<CharacterDetailState> mapEventToState(
      CharacterDetailEvent event) async* {
    if (event is AddCharacterDetail) {
      yield CharacterDetailState(
          charactersDetailsList: event.charactersDetails);
    }
  }

  @override
  CharacterDetailState fromJson(Map<String, dynamic> json) {
    final charact =
        new CharactersDetailsList.fromJsonList(json['charactersDetails']);
    return CharacterDetailState(charactersDetailsList: charact.items);
  }

  @override
  Map<String, List<dynamic>> toJson(CharacterDetailState state) =>
      {'charactersDetails': state.charactersDetails};
}
