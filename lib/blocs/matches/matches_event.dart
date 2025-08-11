part of 'matches_bloc.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object> get props => [];
}

class SetMatches extends MatchesEvent {
  final List<VisualMatch> matches;

  const SetMatches(this.matches);

  @override
  List<Object> get props => [matches];
}
