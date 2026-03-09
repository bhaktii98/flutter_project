import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/res/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/responsive_center.dart';
import '../../presentation/state/auth_notifier.dart';
import 'register_page.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthNotifier>();
    await auth.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  Future<void> _signInWithGoogle() async {
    final auth = context.read<AuthNotifier>();
    await auth.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<AuthNotifier>(
              builder: (context, auth, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text('Welcome back 👋', style: AppTextStyles.h1),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to manage your tasks across devices.',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 32),
                    if (auth.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Material(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.error_outline,
                                color: Colors.red),
                            title: Text(
                              auth.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () =>
                                  context.read<AuthNotifier>().clearError(),
                            ),
                          ),
                        ),
                      ),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Sign In',
                      isLoading: auth.isLoading,
                      onPressed: auth.isLoading ? null : _submit,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: auth.isLoading
                            ? null
                            : () => Navigator.of(context)
                                .pushNamed(RegisterPage.routeName),
                        child: const Text("Don't have an account? Sign up"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Continue with Google',
                      expanded: true,
                      isLoading: auth.isLoading,
                      onPressed: auth.isLoading ? null : _signInWithGoogle,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


