import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/config/env.dart';
import 'dart:convert';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: ''));

    try {
      // Validate passwords match
      // if (event.password != event.confirmPassword) {
      //   emit(state.copyWith(
      //     isLoading: false,
      //     error: 'Passwords do not match',
      //   ));
      //   return;
      // }
      // // Validate email format
      // final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      // if (!emailRegex.hasMatch(event.email)) {
      //   emit(state.copyWith(
      //       isLoading: false, error: 'Please enter a valid email address'));
      //   return;
      // }

      // // Validate password length
      // if (event.password.length < 6) {
      //   emit(state.copyWith(
      //       isLoading: false, error: 'Password must be at least 6 characters'));
      //   return;
      // }

      final response = await http.post(
        Uri.parse('${Env.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': event.fullName,
          'email': event.email,
          'username': event.username,
          'password': event.password,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 500) {
        final error =
            jsonDecode(response.body)['error'] ?? 'User already exists';
        emit(state.copyWith(
          isLoading: false,
          error: error,
        ));
        return;
      }

      if (response.statusCode != 201) {
        final error = jsonDecode(response.body)['error'] ?? 'Signup failed';
        emit(state.copyWith(
          isLoading: false,
          error: error,
        ));
        return;
      }

      final responseData = jsonDecode(response.body);
      final user = responseData['user'];
      final token = responseData['token'];

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
