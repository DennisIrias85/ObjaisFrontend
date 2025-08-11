part of 'boat_bloc.dart';

abstract class BoatEvent extends Equatable {
  const BoatEvent();

  @override
  List<Object?> get props => [];
}

class SaveBoatEvent extends BoatEvent {
  final Boat boat;

  const SaveBoatEvent(this.boat);

  @override
  List<Object?> get props => [boat];
}

class CreateBoatEvent extends BoatEvent {
  final String imageUrl;
  final String model;
  final String brand;
  final String horsePower;
  final String price;
  final String year;
  final String category;
  final String collectionId;
  final bool isPublic;
  final File? itemImage;

  const CreateBoatEvent({
    required this.imageUrl,
    required this.model,
    required this.brand,
    required this.horsePower,
    required this.price,
    required this.year,
    required this.category,
    required this.collectionId,
    required this.isPublic,
    this.itemImage,
  });

  @override
  List<Object?> get props => [
        imageUrl,
        model,
        brand,
        horsePower,
        price,
        year,
        category,
        collectionId,
        isPublic,
        itemImage,
      ];
}

class ClearBoatEvent extends BoatEvent {}
