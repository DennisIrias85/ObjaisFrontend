import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/art_data.dart';
import '../../services/art_service.dart';
import 'dart:io';
import '../collection/collection_bloc.dart';
part 'art_detail_event.dart';
part 'art_detail_state.dart';

class ArtDetailBloc extends Bloc<ArtDetailEvent, ArtDetailState> {
  final ArtService _artService;

  ArtDetailBloc({ArtService? artService})
      : _artService = artService ?? ArtService(),
        super(ArtDetailInitial()) {
    on<SaveArtDetailEvent>(_onSaveArtDetail);
    on<CreateArtDetailEvent>(_onCreateArtDetail);
    on<ClearArtDetailEvent>((event, emit) => emit(ArtDetailInitial()));
  }

  void _onSaveArtDetail(
      SaveArtDetailEvent event, Emitter<ArtDetailState> emit) {
    print('SaveArtDetailEvent');
    print(event.art);

    emit(ArtDetailLoaded(event.art));
  }

  Future<void> _onCreateArtDetail(
      CreateArtDetailEvent event, Emitter<ArtDetailState> emit) async {
    try {
      emit(ArtDetailCreating());

      await _artService.createArtwork(
        imageUrl: event.imageUrl,
        artName: event.artName,
        artistName: event.artistName,
        description: event.description,
        price: event.price,
        year: event.year,
        category: event.category,
        collectionId: event.collectionId,
        isPublic: event.isPublic,
        itemImage: event.itemImage,
        birthCountry: event.birthCountry,
        size: event.size,
        yearBirth: event.yearBirth,
        auctionHouseResult: event.auctionHouseResult,
        turnoverEvolution: event.turnoverEvolution,
        worldRanking: event.worldRanking,
        subtype: event.subtype,
      );
      emit(ArtDetailCreated());
    } catch (e) {
      emit(ArtDetailError('Failed to create artwork: $e'));
    }
  }
}
