part of 'character_detail_bloc.dart';

@immutable
abstract class CharacterDetailEvent {}

class AddCharacterDetail extends CharacterDetailEvent {
  final List<dynamic> charactersDetails;

  AddCharacterDetail(this.charactersDetails);
}
