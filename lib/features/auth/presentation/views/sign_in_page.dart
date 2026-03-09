import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/res/app_colors.dart';
import '../../../../core/res/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../presentation/state/auth_notifier.dart';
import 'register_page.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/sign-in';

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void initState() {
    super.initState();
    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.buildPrimaryGradient(),
        ),
        child: Stack(
          children: [
            _buildTopIllustration(),
            _buildBottomMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIllustration() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        alignment: Alignment.center,
        child: const Icon(
          Icons.lock_outline,
          size: 90,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomMenu(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height *
              0.5 *
              _bottomMenuHeightUpAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Consumer<AuthNotifier>(
              builder: (context, auth, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Login with email',
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 16),
                        if (auth.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              child: ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
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
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          label: 'Sign-In',
                          isLoading: auth.isLoading,
                          onPressed: auth.isLoading ? null : _submit,
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: auth.isLoading
                                ? null
                                : () => Navigator.of(context)
                                    .pushNamed(RegisterPage.routeName),
                            child: const Text(
                              "Don't have an account? Sign up",
                              style: TextStyle(color: AppColors.themeColor),
                            ),
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
                          isLoading: auth.isLoading,
                          onPressed:
                              auth.isLoading ? null : _signInWithGoogle,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
