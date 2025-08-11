import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/blocs/signin/signin_bloc.dart';
import 'package:my_project/screens/sign_in_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>(
      builder: (context, state) {
        if (!state.isSuccess || state.token == null) {
          // User is not logged in, redirect to sign in
          return SignInScreen(
            onAuthSuccess: () {
              // After successful login, pop back to the original screen
              Navigator.of(context).pop();
            },
          );
        }
        // User is logged in, show the protected content
        return child;
      },
    );
  }
}
