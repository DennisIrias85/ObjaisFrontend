import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/blocs/signin/signin_bloc.dart';
import 'package:my_project/colors.dart';
import 'sign_up_screen.dart';
import 'package:my_project/colors.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback? onAuthSuccess;

  const SignInScreen({super.key, this.onAuthSuccess});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign in successful!')),
          );
          if (widget.onAuthSuccess != null) {
            widget.onAuthSuccess!();
          }
        }
        if (state.error != '') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: AppColors.backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/auth_logo.png',
                        // height: 80,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 600,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter your details to proceed further',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'Enter your email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'catherine.shaw@gmail.com',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                suffixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  color: AppColors.primaryColor,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Remember me',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle recover password
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primaryColor,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    'Recover password',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocBuilder<SigninBloc, SigninState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          context.read<SigninBloc>().add(
                                                SigninSubmitted(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                ),
                                              );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: state.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     _buildSocialButton(
                          //       onPressed: () {},
                          //       icon: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 32,
                          //         ),
                          //         child: Image.asset(
                          //           'assets/images/google.png',
                          //           height: 24,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 16),
                          //     _buildSocialButton(
                          //       onPressed: () {},
                          //       icon: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 32,
                          //         ),
                          //         child: Image.asset(
                          //           'assets/images/facebook.png',
                          //           height: 24,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 16),
                          //     _buildSocialButton(
                          //       onPressed: () {},
                          //       icon: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 32,
                          //         ),
                          //         child: Image.asset(
                          //           'assets/images/twitter.png',
                          //           height: 24,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    Widget? child,
    Widget? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon ?? child!,
        color: Colors.grey[600],
      ),
    );
  }
}
