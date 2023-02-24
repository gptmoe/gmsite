import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/features/authentication/providers/register_state.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../resources/widgets/dialogs/error_dialogs.dart';

final registerStateNotifierProvider =
    StateNotifierProvider<RegisterStateNotifier, RegisterState>(
        (ref) => RegisterStateNotifier());

class RegisterStateNotifier extends StateNotifier<RegisterState> {
  RegisterStateNotifier()
      : super(
          RegisterState(
              email: '',
              firstName: '',
              lastName: '',
              registering: false,
              password: 'Qawsed1-'),
        );

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  void setLastName(String value) {
    state = state.copyWith(lastName: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    state = state.copyWith(registering: true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: state.email!, password: state.password!);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: state.firstName,
          id: credential.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=${state.email!.toLowerCase()}',
          lastName: state.lastName,
        ),
      );

      if (!mounted) return;
      Navigator.of(context)
        ..pop()
        ..pop();
    } catch (e) {
      state = state.copyWith(registering: false);
      await ErrorDialogs.show(context, errorMessage: '$e');
    }
  }

  void generateRandomData() {
    final faker = Faker();
    final firstName = faker.person.firstName();
    final lastName = faker.person.lastName();
    final email =
        '${firstName.toLowerCase()}.${lastName.toLowerCase()}@${faker.internet.domainName()}';

    state = state.copyWith(
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
