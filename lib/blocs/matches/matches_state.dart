part of 'matches_bloc.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class MatchesInitial extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<VisualMatch> matches;

  const MatchesLoaded(this.matches);

  @override
  List<Object> get props => [matches];
}
