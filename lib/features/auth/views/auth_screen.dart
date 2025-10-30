import 'package:auto_route/auto_route.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/features/auth/controllers/auth_controller.dart';
import 'package:blogspace/features/auth/controllers/login_controller.dart';
import 'package:blogspace/features/auth/models/auth_response.dart';
import 'package:blogspace/features/auth/widgets/toggle_buttons.dart';
import 'package:blogspace/shared/app_flushbar.dart';
import 'package:blogspace/shared/loading_screen.dart';
import 'package:flutter/material.dart' hide ToggleButtons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@RoutePage()
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordIsObscure = true;

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.saveAndValidate()) {
      if (ref.read(isLoginProvider)) {
        print('Login with: ${_emailController.text}');
        // Call your login function here
        ref
            .read(authNotifierProvider.notifier)
            .login(_emailController.text, _passwordController.text);
      } else {
        print(
          'Sign up with: ${_usernameController.text}, ${_emailController.text}',
        );
        ref
            .read(authNotifierProvider.notifier)
            .register(
              _emailController.text,
              _passwordController.text,
              _usernameController.text,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (_, next) {
      if (next.hasError) {
        showCustomFlushbar(context, message: next.error.toString(), isError: true);
        return;
      }
      if (next is AsyncData<AuthResponse>) {
        context.router.replaceAll([BlogsRoute()]);
        return;
      }
    });

    final isLogin = ref.watch(isLoginProvider);

    return ref.watch(authNotifierProvider).isLoading
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ShadForm(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(20),
                    // Logo and Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit_document,
                            color: Color(0xFF3B82F6),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'BlogSpace',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your space to write and connect.',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),

                    // Toggle Buttons
                    ToggleButtons(),
                    const SizedBox(height: 24),

                    // Username Field (only for Sign Up)
                    if (!isLogin) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ShadInputFormField(
                        id: 'username',
                        controller: _usernameController,
                        placeholder: const Text('Enter your username'),
                        keyboardType: TextInputType.text,
                        validator: (value) => _validateUsername(value),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShadInputFormField(
                      id: 'email',
                      controller: _emailController,
                      placeholder: const Text('Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateEmail(value),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShadInputFormField(
                      id: 'password',
                      controller: _passwordController,
                      placeholder: const Text('Enter your password'),
                      obscureText: passwordIsObscure,
                      validator: (value) => _validatePassword(value),
                      trailing: InkWell(
                        onTap: () {
                          setState(() {
                            passwordIsObscure = !passwordIsObscure;
                          });
                        },
                        child: Icon(
                          passwordIsObscure ? Iconsax.eye_slash : Iconsax.eye,
                          size: 18,
                        ),
                      ),
                    ),

                    // Forgot Password (only for Login)
                    if (isLogin) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            print('Forgot Password clicked');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Submit Button
                    ShadButton(
                      onPressed: _handleSubmit,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          isLogin ? 'Log In' : 'Create Account',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Terms and Privacy (only for Sign Up)
                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          children: const [
                            TextSpan(text: 'By signing up, you agree to our '),
                            TextSpan(
                              text: 'Terms & Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFF3B82F6),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
