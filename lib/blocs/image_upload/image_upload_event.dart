part of 'image_upload_bloc.dart';

abstract class ImageUploadEvent extends Equatable {
  const ImageUploadEvent();

  @override
  List<Object> get props => [];
}

class UploadImageEvent extends ImageUploadEvent {
  final File imageFile;

  const UploadImageEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}
