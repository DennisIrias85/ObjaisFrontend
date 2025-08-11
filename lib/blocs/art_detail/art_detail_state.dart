part of 'art_detail_bloc.dart';

abstract class ArtDetailState extends Equatable {
  const ArtDetailState();

  @override
  List<Object?> get props => [];
}

class ArtDetailInitial extends ArtDetailState {}

class ArtDetailLoaded extends ArtDetailState {
  final ArtData art;

  const ArtDetailLoaded(this.art);

  @override
  List<Object?> get props => [art];
}

class ArtDetailCreating extends ArtDetailState {}

class ArtDetailCreated extends ArtDetailState {}

class ArtDetailError extends ArtDetailState {
  final String message;

  const ArtDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
