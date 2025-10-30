import 'package:auto_route/auto_route.dart';
import 'package:blogspace/features/auth/controllers/login_controller.dart';
import 'package:blogspace/features/auth/widgets/toggle_buttons.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordIsObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
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
              if (!ref.watch(isLoginProvider)) ...[
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
                  controller: _usernameController,
                  placeholder: const Text('Enter your username'),
                  keyboardType: TextInputType.text,
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
                controller: _emailController,
                placeholder: const Text('Enter your email'),
                keyboardType: TextInputType.emailAddress,
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
                controller: _passwordController,
                placeholder: const Text('Enter your password'),
                obscureText: passwordIsObscure,
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
              if (ref.watch(isLoginProvider)) ...[
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
                onPressed: () {
                  if (ref.watch(isLoginProvider)) {
                    print('Login with: ${_emailController.text}');
                  } else {
                    print(
                      'Sign up with: ${_usernameController.text}, ${_emailController.text}',
                    );
                  }
                },
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    ref.watch(isLoginProvider) ? 'Log In' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Terms and Privacy (only for Sign Up)
              if (!ref.watch(isLoginProvider)) ...[
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
