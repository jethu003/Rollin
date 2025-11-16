import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/domain/usecases/register_usecase.dart';
import 'package:rollin_user/data/repositories/create_user_repositoryimpl.dart';
import 'package:rollin_user/presentation/authentication/login.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_bloc.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_event.dart';
import 'package:rollin_user/presentation/bloc/create_user/create_user_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/widgets/custom_button.dart';
import 'package:rollin_user/presentation/widgets/flushbar.dart';
import 'package:rollin_user/presentation/widgets/textform_field.dart';

class UserRegisterScreen extends StatelessWidget {
  UserRegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                border: Border.all(color: AppColours.shineWhite, width: 1),
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
                    showFlushBar(context, "Registered Successfully!");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => UserLoginScreen()),
                    );
                  } else if (state is RegisterFailure) {
                    showFlushBar(context, state.message, backgroundColor: Colors.red);
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              color: AppColours.shineWhite,
                              fontSize: size.width < 600 ? 18 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Name
                        CommonTextField(
                          controller: nameController,
                          hintText: 'User Name',
                          onTextChanged: (_) {},
                          icon: const Icon(Icons.abc, color: AppColours.insideGrey),
                          isPasswordField: false,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        CommonTextField(
                          controller: emailController,
                          hintText: 'Enter Email',
                          onTextChanged: (_) {},
                          icon: const Icon(Icons.email_outlined, color: AppColours.insideGrey),
                          isPasswordField: false,
                        ),
                        const SizedBox(height: 16),

                        // Password
                        CommonTextField(
                          controller: passwordController,
                          hintText: 'Enter Password',
                          onTextChanged: (_) {},
                          icon: const Icon(Icons.password_outlined, color: AppColours.insideGrey),
                          isPasswordField: true,
                        ),
                        const SizedBox(height: 24),

                        state is RegisterLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                buttonText: 'REGISTER',
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  final name = nameController.text.trim();
                                  final email = emailController.text.trim();
                                  final password = passwordController.text.trim();

                                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                                    showFlushBar(
                                      context,
                                      "Please fill all fields",
                                      backgroundColor: Colors.red,
                                    );
                                    return;
                                  }

                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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

                                  BlocProvider.of<RegisterBloc>(context).add(
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
