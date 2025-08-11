import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/blocs/signup/signup_bloc.dart';

class AuthProvider extends StatelessWidget {
  final Widget child;

  const AuthProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupBloc(),
        ),
      ],
      child: child,
    );
  }
}
