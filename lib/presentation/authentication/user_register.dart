import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rollin_user/presentation/bloc/create_user/create_user_bloc.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_event.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/profile/complete_profile.dart';
import 'package:rollin_user/presentation/widgets/custom_button.dart';
import 'package:rollin_user/presentation/widgets/flushbar.dart';
import 'package:rollin_user/presentation/widgets/textform_field.dart';
import 'package:rollin_user/domain/usecases/register_usecase.dart';
import 'package:rollin_user/data/repositories/create_user_repositoryimpl.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true; 

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => RegisterBloc(
        registerUserUseCase: RegisterUserUseCase(
          AuthRepositoryImpl(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
      ),
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
              child: BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompleteProfile(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                        ),
                      ),
                    );
                  } else if (state is RegisterFailure) {
                    showFlushBar(
                      context,
                      state.message,
                      backgroundColor: Colors.red,
                    );
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'REGISTER',
                          style: TextStyle(
                            color: AppColours.shineWhite,
                            fontSize: size.width < 600 ? 18 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Name
                        CommonTextField(
                          controller: nameController,
                          hintText: 'User Name',
                          onTextChanged: (_) {},
                          icon: const Icon(
                            Icons.person_outline,
                            color: AppColours.insideGrey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Email
                        CommonTextField(
                          controller: emailController,
                          hintText: 'Enter Email',
                          onTextChanged: (_) {},
                          icon: const Icon(
                            Icons.email_outlined,
                            color: AppColours.insideGrey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Password with TOGGLE 
                        CommonTextField(
                          controller: passwordController,
                          hintText: 'Enter Password',
                          isPasswordField: _obscurePassword,
                          onTextChanged: (_) {},
                          icon: const Icon(
                            Icons.lock_outline,
                            color: AppColours.insideGrey,
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
                        ),

                        const SizedBox(height: 24),

                        state is RegisterLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                buttonText: 'REGISTER',
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  final name =
                                      nameController.text.trim();
                                  final email =
                                      emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty) {
                                    showFlushBar(
                                      context,
                                      "Please fill all fields",
                                      backgroundColor: Colors.red,
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

                                  context.read<RegisterBloc>().add(
                                        RegisterButtonPressed(
                                          name: name,
                                          email: email,
                                          password: password,
                                        ),
                                      );
                                },
                                buttonColor: AppColours.primaryColor,
                                textColor: AppColours.shineBlack,
                                padding: EdgeInsets.zero,
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
