part of 'google_lens_bloc.dart';

abstract class GoogleLensEvent extends Equatable {
  const GoogleLensEvent();

  @override
  List<Object> get props => [];
}

class SearchImageEvent extends GoogleLensEvent {
  final String image;
  final String link;
  final String title;

  const SearchImageEvent({
    required this.image,
    required this.link,
    required this.title,
  });

  @override
  List<Object> get props => [image, link, title];
}

class ResetGoogleLensEvent extends GoogleLensEvent {}
