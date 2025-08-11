part of 'google_lens_bloc.dart';

abstract class GoogleLensState extends Equatable {
  const GoogleLensState();

  @override
  List<Object> get props => [];
}

class GoogleLensInitial extends GoogleLensState {}

class GoogleLensLoading extends GoogleLensState {}

class GoogleLensSuccess extends GoogleLensState {
  final Map<String, dynamic> data;

  const GoogleLensSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class GoogleLensError extends GoogleLensState {
  final String message;

  const GoogleLensError(this.message);

  @override
  List<Object> get props => [message];
}
