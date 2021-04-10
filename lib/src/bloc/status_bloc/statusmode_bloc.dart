import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'statusmode_event.dart';
part 'statusmode_state.dart';

class StatusmodeBloc extends HydratedBloc<StatusmodeEvent, StatusmodeState> {
  StatusmodeBloc() : super(StatusmodeState(status: false)) {
    hydrate();
  }
  @override
  Stream<StatusmodeState> mapEventToState(StatusmodeEvent event) async* {
    if (event is ChangeStatusMode) {
      yield StatusmodeState(status: event.status);
    }
  }

  @override
  StatusmodeState fromJson(Map<String, dynamic> json) =>
      StatusmodeState(status: json['status']);
  @override
  Map<String, bool> toJson(StatusmodeState state) =>
      {'status': state.statusMode};
}
