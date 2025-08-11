part of 'art_detail_bloc.dart';

abstract class ArtDetailEvent extends Equatable {
  const ArtDetailEvent();

  @override
  List<Object?> get props => [];
}

class SaveArtDetailEvent extends ArtDetailEvent {
  final ArtData art;

  const SaveArtDetailEvent(this.art);

  @override
  List<Object?> get props => [art];
}

class CreateArtDetailEvent extends ArtDetailEvent {
  final String imageUrl;
  final String artName;
  final String artistName;
  final String description;
  final String price;
  final String year;
  final String category;
  final String collectionId;
  final bool isPublic;
  final File? itemImage;
  final String collectionName;
  final String birthCountry;
  final String size;
  final String yearBirth;
  final String auctionHouseResult;
  final String turnoverEvolution;
  final String worldRanking;
  final String subtype;

  const CreateArtDetailEvent({
    required this.imageUrl,
    required this.artName,
    required this.artistName,
    required this.description,
    required this.price,
    required this.year,
    required this.category,
    required this.collectionId,
    required this.isPublic,
    this.itemImage,
    required this.collectionName,
    required this.birthCountry,
    required this.size,
    required this.yearBirth,
    required this.auctionHouseResult,
    required this.turnoverEvolution,
    required this.worldRanking,
    required this.subtype,
  });

  @override
  List<Object?> get props => [
        imageUrl,
        artName,
        artistName,
        description,
        price,
        year,
        category,
        collectionId,
        isPublic,
        itemImage,
        collectionName,
        birthCountry,
        size,
        yearBirth,
        auctionHouseResult,
        turnoverEvolution,
        worldRanking,
        subtype,
      ];
}

class ClearArtDetailEvent extends ArtDetailEvent {}
