import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/blocs/signup/signup_bloc.dart';
import 'package:my_project/colors.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onAuthSuccess;

  const SignUpScreen({super.key, this.onAuthSuccess});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up successful!')),
          );
          if (widget.onAuthSuccess != null) {
            widget.onAuthSuccess!();
          }
        }
        if (state.error != '') {
          print(state.error);
          print("############");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Color(0xFF410332)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/auth_logo.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Take the next step and sign up to your account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    _buildTextField(
                                      controller: _fullNameController,
                                      label: 'Full Name',
                                      hintText: 'Catherine Shaw',
                                      suffixIcon: Icons.person_outline_rounded,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      hintText: 'Enter your email',
                                      suffixIcon: Icons.mail_outline_rounded,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildTextField(
                                      controller: _usernameController,
                                      label: 'Username',
                                      hintText: 'Create your username',
                                      suffixIcon: Icons.info_outline_rounded,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildTextField(
                                      controller: _passwordController,
                                      label: 'Password',
                                      hintText: 'Enter your password',
                                      isPassword: true,
                                      obscureText: _obscurePassword,
                                      onTogglePassword: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    _buildTextField(
                                      controller: _confirmPasswordController,
                                      label: 'Confirm Password',
                                      hintText: 'Confirm your password',
                                      isPassword: true,
                                      obscureText: _obscureConfirmPassword,
                                      onTogglePassword: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                BlocBuilder<SignupBloc, SignupState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: state.isLoading
                                            ? null
                                            : () {
                                                context.read<SignupBloc>().add(
                                                      SignupSubmitted(
                                                        fullName:
                                                            _fullNameController
                                                                .text,
                                                        email: _emailController
                                                            .text,
                                                        username:
                                                            _usernameController
                                                                .text,
                                                        password:
                                                            _passwordController
                                                                .text,
                                                        confirmPassword:
                                                            _confirmPasswordController
                                                                .text,
                                                      ),
                                                    );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: state.isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white)
                                            : const Text(
                                                'Submit and Continue',
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    IconData? suffixIcon,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword ? (obscureText ?? true) : false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ?? true
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: onTogglePassword,
                  )
                : Icon(suffixIcon, color: AppColors.primaryColor),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFA00D9)),
            ),
          ),
        ),
      ],
    );
  }
}
