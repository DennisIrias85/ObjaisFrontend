import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/config/env.dart';
import 'package:my_project/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(const SigninState()) {
    on<SigninSubmitted>(_onSigninSubmitted);
  }

  Future<void> _onSigninSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: ''));

    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': event.email,
          'password': event.password,
        }),
      );

      if (response.statusCode == 400 || response.statusCode == 401) {
        final error =
            jsonDecode(response.body)['error'] ?? 'Invalid credentials';
        emit(state.copyWith(
          isLoading: false,
          error: error,
        ));
        return;
      }

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body)['error'] ?? 'Sign in failed';
        emit(state.copyWith(
          isLoading: false,
          error: error,
        ));
        return;
      }

      final responseData = jsonDecode(response.body);
      final user = responseData['user'];
      final token = responseData['token'];

      print('DEBUG: Full login response: $responseData');

      // ✅ Save token securely
      await StorageService.saveToken(token);

      // ✅ Save user ID in SharedPreferences safely
      final prefs = await SharedPreferences.getInstance();
      final userId = user['_id'] ?? user['id'];

      if (userId != null && userId is String) {
        await prefs.setString('user_id', userId);
        print('✅ Saved user_id: $userId');
      } else {
        throw Exception('❌ User ID is null or not a string: $userId');
      }

      // ✅ Emit success state
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        user: user,
        token: token,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
