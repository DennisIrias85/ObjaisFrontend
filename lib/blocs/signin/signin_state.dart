part of 'signin_bloc.dart';

class SigninState extends Equatable {
  final String? email;
  final String? password;
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic>? user;
  final String? token;

  const SigninState({
    this.email,
    this.password,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.user,
    this.token,
  });

  SigninState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    bool? isSuccess,
    Map<String, dynamic>? user,
    String? token,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isLoading,
        error,
        isSuccess,
        user,
        token,
      ];
}
