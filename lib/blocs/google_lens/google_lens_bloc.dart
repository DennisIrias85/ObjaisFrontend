import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'google_lens_event.dart';
part 'google_lens_state.dart';

class GoogleLensBloc extends Bloc<GoogleLensEvent, GoogleLensState> {
  GoogleLensBloc() : super(GoogleLensInitial()) {
    on<SearchImageEvent>(_onSearchImage);
    on<ResetGoogleLensEvent>((event, emit) => emit(GoogleLensInitial()));
  }

  Future<void> _onSearchImage(
    SearchImageEvent event,
    Emitter<GoogleLensState> emit,
  ) async {
    try {
      emit(GoogleLensLoading());

      // Debug
      print('get details');
      print(event.image);
      print(event.link);
      print(event.title);

      // Normalize category: default to Boat on this flow
      final prefs = await SharedPreferences.getInstance();
      final selectedItem = (prefs.getString('selected_item') ?? 'Boat').trim();
      final normalizedCategory =
          (selectedItem.toLowerCase() == 'boat') ? 'Boat' : 'Artwork';

      final url = '${Env.baseUrl}/api/images/scrape-details';
      print('➡️ $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': event.image,
          'link': event.link,
          'title': event.title,
          'category': normalizedCategory, // typically 'Boat' here
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ scrape-details response: $data');

        if (data['success'] == true) {
          // backend returns { success: true, data: {...} }
          emit(GoogleLensSuccess(data['data']));
        } else if (data['isFound'] == false) {
          emit(const GoogleLensError('No image details found'));
        } else {
          emit(const GoogleLensError('Unexpected response format'));
        }
      } else {
        emit(GoogleLensError(
            'Failed to fetch image details: ${response.statusCode}'));
      }
    } catch (e) {
      emit(GoogleLensError('Error searching image: $e'));
    }
  }
}
