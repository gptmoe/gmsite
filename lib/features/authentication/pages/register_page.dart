import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/register_state_notifier.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerStateNotifierProvider);
    final registerStateNotifier =
        ref.watch(registerStateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
          child: Column(
            children: [
              TextField(
                autocorrect: false,
                autofillHints: state.registering ? null : [AutofillHints.email],
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                readOnly: state.registering,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                onChanged: registerStateNotifier.setEmail,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  autocorrect: false,
                  autofillHints:
                      state.registering ? null : [AutofillHints.password],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  onEditingComplete: state.registering
                      ? null
                      : () async {
                          registerStateNotifier.register(context);
                        },
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    registerStateNotifier.setPassword(value);
                  },
                ),
              ),
              TextButton(
                onPressed: state.registering
                    ? null
                    : () async {
                        registerStateNotifier.register(context);
                      },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
