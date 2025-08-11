import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/art_data.dart';
import '../../models/profile_model.dart';
import '../../models/boat.dart';
import '../../repositories/search_repository.dart';

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged({required this.query});

  @override
  List<Object> get props => [query];
}

// States
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class ResetSearch extends SearchEvent {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchResultsLoaded extends SearchState {
  final List<Artwork> artworks;
  final List<Collection> collections;
  final List<Boat> boats;

  const SearchResultsLoaded({
    required this.artworks,
    required this.collections,
    required this.boats,
  });

  @override
  List<Object> get props => [artworks, collections, boats];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;

  SearchBloc({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ResetSearch>((event, emit) => emit(SearchInitial()));
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final results = await _searchRepository.search(event.query);
      print("results");
      print(results);
      emit(SearchResultsLoaded(
        artworks: results.artworks,
        collections: results.collections,
        boats: results.boats,
      ));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
