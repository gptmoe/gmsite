import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../resources/widgets/dialogs/error_dialogs.dart';
import 'login_state.dart';

final loginStateNotifierProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>(
        (ref) => LoginStateNotifier());

class LoginStateNotifier extends StateNotifier<LoginState> {
  LoginStateNotifier()
      : super(LoginState(
          isLoggingIn: false,
          username: '',
          password: '',
        ));

  void setUsername(String value) {
    state = state.copyWith(username: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    state = state.copyWith(isLoggingIn: true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.username,
        password: state.password,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      state = state.copyWith(isLoggingIn: false);

      await ErrorDialogs.show(context, errorMessage: '$e');
    }
  }
}
