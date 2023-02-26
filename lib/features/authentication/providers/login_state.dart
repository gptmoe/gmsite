class LoginState {
  final bool isLoggingIn;
  final String username;
  final String password;

  LoginState({
    required this.isLoggingIn,
    required this.username,
    required this.password,
  });

  LoginState copyWith({
    bool? isLoggingIn,
    String? username,
    String? password,
  }) {
    return LoginState(
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
