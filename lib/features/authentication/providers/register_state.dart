class RegisterState {
  final String? email;
  final String? firstName;
  final String? lastName;
  final bool registering;
  final String? password;

  RegisterState({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.registering,
    required this.password,
  });

  RegisterState copyWith({
    String? email,
    String? firstName,
    String? lastName,
    bool? registering,
    String? password,
  }) {
    return RegisterState(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      registering: registering ?? this.registering,
      password: password ?? this.password,
    );
  }
}
