import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rollin_user/presentation/bloc/login_user/login_user_bloc.dart';
import 'package:rollin_user/presentation/bloc/login_user/login_user_event.dart';
import 'package:rollin_user/presentation/bloc/login_user/login_user_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/bottom_navigator/bottom_navigator.dart';
import 'package:rollin_user/presentation/widgets/custom_button.dart';
import 'package:rollin_user/presentation/widgets/textform_field.dart';
import 'package:rollin_user/presentation/widgets/flushbar.dart';
import 'package:rollin_user/presentation/authentication/user_register.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => LoginBloc(firebaseAuth: FirebaseAuth.instance),
      child: Scaffold(
        backgroundColor: AppColours.shineBlack,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: size.width < 600 ? size.width * 0.9 : 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColours.shineBlack,
                border: Border.all(color: AppColours.shineWhite),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    showFlushBar(
                      context,
                      "Login Successful!",
                      backgroundColor: AppColours.shineBlack,
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BottomNavigator(),
                      ),
                      (_) => false,
                    );
                  } else if (state is LoginFailure) {
                    showFlushBar(
                      context,
                      'Please Register',
                      backgroundColor: AppColours.shineWhite,
                    );
                  }
                },
                builder: (context, state) {
                  final bool isLoading = state is LoginLoading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            color: AppColours.shineWhite,
                            fontSize: size.width < 600 ? 18 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Email
                        CommonTextField(
                          controller: emailController,
                          hintText: 'Enter Email',
                          icon: const Icon(
                            Icons.email_outlined,
                            color: AppColours.insideGrey,
                            size: 18,
                          ),
                          isPasswordField: false,
                          onTextChanged: (_) {},
                        ),
                        const SizedBox(height: 16),

                        /// Password with TOGGLE
                        CommonTextField(
                          controller: passwordController,
                          hintText: 'Enter Password',
                          isPasswordField: _obscurePassword,
                          icon: const Icon(
                            Icons.lock_outline,
                            color: AppColours.insideGrey,
                            size: 18,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColours.insideGrey,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          onTextChanged: (_) {},
                        ),

                        const SizedBox(height: 24),

                        /// Login Button
                        isLoading
                            ? CustomShimmer(
                              baseColor: AppColours.primaryColor,
                                child: CustomButton(
                                  buttonText: 'LOGGING IN...',
                                  onPressed: () {},
                                  buttonColor: AppColours.primaryColor,
                                  textColor: AppColours.shineBlack,
                                  padding: EdgeInsets.zero,
                                ),
                              )
                            : CustomButton(
                                buttonText: 'LOGIN',
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  final email =
                                      emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  if (email.isEmpty ||
                                      password.isEmpty) {
                                    showFlushBar(
                                      context,
                                      "Please fill all fields",
                                      backgroundColor:
                                          AppColours.shineWhite,
                                    );
                                    return;
                                  }

                                  final emailRegex = RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  );

                                  if (!emailRegex.hasMatch(email)) {
                                    showFlushBar(
                                      context,
                                      "Enter a valid email",
                                      backgroundColor: Colors.red,
                                    );
                                    return;
                                  }

                                  if (password.length < 6) {
                                    showFlushBar(
                                      context,
                                      "Password must be at least 6 characters",
                                      backgroundColor: Colors.red,
                                    );
                                    return;
                                  }

                                  context.read<LoginBloc>().add(
                                        LoginButtonPressed(
                                          email: email,
                                          password: password,
                                        ),
                                      );
                                },
                                buttonColor: AppColours.primaryColor,
                                textColor: AppColours.shineBlack,
                                padding: EdgeInsets.zero,
                              ),

                        const SizedBox(height: 16),

                        /// Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Not a user?',
                              style: TextStyle(
                                color: AppColours.shineWhite,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                         UserRegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: AppColours.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
