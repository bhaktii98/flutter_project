import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/res/app_theme.dart';
import 'features/auth/presentation/state/auth_notifier.dart';
import 'features/auth/presentation/views/auth_landing_page.dart';
import 'features/auth/presentation/views/register_page.dart';
import 'features/auth/presentation/views/sign_in_page.dart';
import 'features/todos/presentation/state/todo_notifier.dart';
import 'features/todos/presentation/views/todo_list_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()..init()),
        ChangeNotifierProxyProvider<AuthNotifier, TodoNotifier>(
          create: (_) => TodoNotifier(),
          update: (_, auth, todos) =>
              (todos ?? TodoNotifier())..setUser(auth.currentUser),
        ),
      ],
      child: Consumer<AuthNotifier>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            theme: buildAppTheme(),
            routes: {
              AuthLandingPage.routeName: (_) => const AuthLandingPage(),
              SignInPage.routeName: (_) => const SignInPage(),
              RegisterPage.routeName: (_) => const RegisterPage(),
              TodoListPage.routeName: (_) => const TodoListPage(),
            },
            home: auth.isCheckingAuth
                ? const _SplashScreen()
                : auth.isAuthenticated
                    ? const TodoListPage()
                    : const AuthLandingPage(),
          );
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
