import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/visual_match.dart';

part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesBloc() : super(MatchesInitial()) {
    on<SetMatches>(_onSetMatches);
  }

  void _onSetMatches(SetMatches event, Emitter<MatchesState> emit) {
    emit(MatchesLoaded(event.matches));
  }
}
