part of 'characters_bloc.dart';

@immutable
abstract class CharactersEvent {}

class ChangeCharacters extends CharactersEvent {
  final List<Character> characters;

  ChangeCharacters(this.characters);
}
