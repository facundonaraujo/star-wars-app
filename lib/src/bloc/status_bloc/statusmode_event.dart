part of 'statusmode_bloc.dart';

@immutable
abstract class StatusmodeEvent {}

class ChangeStatusMode extends StatusmodeEvent {
  final bool status;

  ChangeStatusMode(this.status);
}
