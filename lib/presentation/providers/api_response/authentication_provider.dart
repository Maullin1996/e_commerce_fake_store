import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationApiResponse {
  final bool isLoading;
  final String? errorMessage;
  final String token;
  final String? username;
  final String? password;

  AuthenticationApiResponse({
    this.username,
    this.password,
    this.isLoading = false,
    this.errorMessage,
    this.token = '',
  });

  AuthenticationApiResponse copyWith({
    bool? isLoading,
    String? errorMessage,
    String? token,
    String? username,
    String? password,
  }) {
    return AuthenticationApiResponse(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
    );
  }
}

class AuthenticationNotifier extends StateNotifier<AuthenticationApiResponse> {
  AuthenticationNotifier() : super(AuthenticationApiResponse());

  final ApiServices _apiServices = ApiServices();

  Future<void> fetchAuthentication(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final signInResult = await _apiServices.fetchAuth(
      username: username,
      password: password,
    );
    state = signInResult.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (token) => state.copyWith(
        token: token.token,
        isLoading: false,
        errorMessage: null,
        username: username,
        password: password,
      ),
    );
  }

  void logOutUser() {
    state = state.copyWith(token: '', username: null, password: null);
  }
}

final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationApiResponse>((
      ref,
    ) {
      return AuthenticationNotifier(); // Pasar el Ref al constructor
    });
