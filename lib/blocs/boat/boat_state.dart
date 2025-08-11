part of 'boat_bloc.dart';

abstract class BoatState extends Equatable {
  const BoatState();

  @override
  List<Object?> get props => [];
}

class BoatInitial extends BoatState {}

class BoatLoaded extends BoatState {
  final Boat boat;

  const BoatLoaded(this.boat);

  @override
  List<Object?> get props => [boat];
}

class BoatCreating extends BoatState {}

class BoatCreated extends BoatState {}

class BoatError extends BoatState {
  final String message;

  const BoatError(this.message);

  @override
  List<Object?> get props => [message];
}
