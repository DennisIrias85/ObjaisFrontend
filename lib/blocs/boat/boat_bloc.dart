import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/boat.dart';
import '../../services/boat_service.dart';
import 'dart:io';
part 'boat_event.dart';
part 'boat_state.dart';

class BoatBloc extends Bloc<BoatEvent, BoatState> {
  final BoatService _boatService;

  BoatBloc({BoatService? boatService})
      : _boatService = boatService ?? BoatService(),
        super(BoatInitial()) {
    on<SaveBoatEvent>(_onSaveBoat);
    on<CreateBoatEvent>(_onCreateBoat);
    on<ClearBoatEvent>((event, emit) => emit(BoatInitial()));
  }

  void _onSaveBoat(SaveBoatEvent event, Emitter<BoatState> emit) {
    emit(BoatLoaded(event.boat));
  }

  Future<void> _onCreateBoat(
      CreateBoatEvent event, Emitter<BoatState> emit) async {
    try {
      emit(BoatCreating());

      await _boatService.createBoat(
        imageUrl: event.imageUrl,
        model: event.model,
        brand: event.brand,
        horsePower: event.horsePower,
        price: event.price,
        year: event.year,
        category: event.category,
        collectionId: event.collectionId,
        isPublic: event.isPublic,
        itemImage: event.itemImage,
      );
      emit(BoatCreated());
    } catch (e) {
      emit(BoatError('Failed to create boat: $e'));
    }
  }
}
