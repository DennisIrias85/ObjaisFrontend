part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String fullName;
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  const SignupSubmitted({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props =>
      [fullName, email, username, password, confirmPassword];
}
