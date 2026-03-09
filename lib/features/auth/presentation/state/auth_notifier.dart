import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/auth_repository.dart';
import '../../domain/entities/app_user.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;

  AppUser? _user;
  bool _isLoading = false;
  bool _isCheckingAuth = true;
  String? _error;
  StreamSubscription<AppUser?>? _authSub;

  AuthNotifier({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  AppUser? get currentUser => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  bool get isCheckingAuth => _isCheckingAuth;
  String? get error => _error;

  Future<void> init() async {
    _authSub = _repository.authStateChanges().listen((user) {
      _user = user;
      _isCheckingAuth = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _error = null;
      _user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String email, String password) async {
    _setLoading(true);
    try {
      _error = null;
      _user = await _repository.registerWithEmail(
        email: email,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      _error = null;
      _user = await _repository.signInWithGoogle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repository.signOut();
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}


