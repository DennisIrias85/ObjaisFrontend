part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String? fullName;
  final String? email;
  final String? username;
  final String? password;
  final String? confirmPassword;
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic>? user;
  final String? token;

  const SignupState({
    this.fullName,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.user,
    this.token,
  });

  SignupState copyWith({
    String? fullName,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? error,
    bool? isSuccess,
    Map<String, dynamic>? user,
    String? token,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        username,
        password,
        confirmPassword,
        isLoading,
        error,
        isSuccess,
        user,
        token,
      ];
}
