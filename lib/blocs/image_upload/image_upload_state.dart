part of 'image_upload_bloc.dart';

abstract class ImageUploadState extends Equatable {
  const ImageUploadState();

  @override
  List<Object> get props => [];
}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploadLoading extends ImageUploadState {}

class ImageUploadSuccess extends ImageUploadState {
  final List<VisualMatch> matches;

  const ImageUploadSuccess(this.matches);

  @override
  List<Object> get props => [matches];
}

class ImageUploadError extends ImageUploadState {
  final String message;

  const ImageUploadError(this.message);

  @override
  List<Object> get props => [message];
}
