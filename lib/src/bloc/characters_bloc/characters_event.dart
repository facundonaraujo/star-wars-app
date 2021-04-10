part of 'characters_bloc.dart';

@immutable
abstract class CharactersEvent {}

class ChangeCharacters extends CharactersEvent {
  final List<dynamic> characters;

  ChangeCharacters(this.characters);
}
