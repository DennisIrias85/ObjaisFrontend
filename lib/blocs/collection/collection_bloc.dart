import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/collection_service.dart';

class Collection extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String? ownerId; // FIX: Added the ownerId field

  final File? imageFile;
  final List<dynamic>? artworks;
  final String type;
  final List<dynamic>? boats;

  const Collection(
      {required this.id,
      required this.name,
      this.imageUrl,
      this.imageFile,
      this.artworks,
      this.boats,
      required this.type,
      this.ownerId // FIX: Added ownerId to the constructor
      });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      artworks: json['artworks'] as List? ?? [],
      type: json['type'] as String,
      boats: json['boats'] as List? ?? [],
      ownerId: (json['owner'] is Map<String, dynamic>)
          ? json['owner']['_id'] as String?
          : json['owner'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, imageUrl, imageFile, ownerId]; // FIX: Added ownerId to props
}

// Events
abstract class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadCollections extends CollectionEvent {}

class CreateCollection extends CollectionEvent {
  final String name;
  final File? imageFile;

  const CreateCollection({required this.name, this.imageFile});

  @override
  List<Object?> get props => [name, imageFile];
}

class SelectCollection extends CollectionEvent {
  final Collection collection;

  const SelectCollection(this.collection);

  @override
  List<Object?> get props => [collection];
}

// States
abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object?> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<Collection> collections;
  final Collection? selectedCollection;

  const CollectionLoaded({
    required this.collections,
    this.selectedCollection,
  });

  @override
  List<Object?> get props => [collections, selectedCollection];
}

class CollectionError extends CollectionState {
  final String message;

  const CollectionError(this.message);

  @override
  List<Object?> get props => [message];
}

class CollectionCreated extends CollectionState {}

// Bloc
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionService _collectionService;

  CollectionBloc(this._collectionService) : super(CollectionInitial()) {
    on<LoadCollections>(_onLoadCollections);
    on<CreateCollection>(_onCreateCollection);
    on<SelectCollection>(_onSelectCollection);
  }

  Future<void> _onLoadCollections(
      LoadCollections event, Emitter<CollectionState> emit) async {
    emit(CollectionLoading());
    try {
      final selected_item = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('selected_item'));

      final collectionsData =
          await _collectionService.getCollections(selected_item ?? 'Artwork');
      print(
          '🧾 Raw collection data from backend: $collectionsData'); // <-- ADD THIS

      print(collectionsData);

      final collections =
          collectionsData.map((data) => Collection.fromJson(data)).toList();
      print('collections');
      emit(CollectionLoaded(collections: collections));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onCreateCollection(
    CreateCollection event,
    Emitter<CollectionState> emit,
  ) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(CollectionLoading());

      final selected_item = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('selected_item'));

      try {
        if (event.imageFile != null) {
          final response = await _collectionService.createCollection(
            name: event.name,
            imageFile: event.imageFile!,
            type: selected_item ?? 'Artwork',
          );
          print("✅ Collection created: $response");

          final newCollection = Collection.fromJson(response);
          final updatedCollections =
              List<Collection>.from(currentState.collections)
                ..insert(0, newCollection);

          emit(
              CollectionCreated()); // ✅ NEW: signal success so UI can close modal

          emit(CollectionLoaded(
            collections: updatedCollections,
            selectedCollection: currentState.selectedCollection,
          ));
        }
      } catch (e) {
        emit(CollectionError(e.toString()));
      }
    }
  }

  void _onSelectCollection(
      SelectCollection event, Emitter<CollectionState> emit) {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(CollectionLoaded(
        collections: currentState.collections,
        selectedCollection: event.collection,
      ));
    }
  }
}
