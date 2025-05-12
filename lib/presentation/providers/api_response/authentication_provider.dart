import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class AuthenticationApiResponse {
  final bool isLoading;
  final String errorMessage;
  final String token;
  final String username;
  final String password;

  AuthenticationApiResponse({
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage = '',
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
  Ref ref;

  AuthenticationNotifier(this.ref, this.keyValueStorageService)
    : super(AuthenticationApiResponse());

  final ApiServices _apiServices = ApiServices();
  final KeyValueStorageService keyValueStorageService;

  Future<void> fetchAuthentication(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    final signInResult = await _apiServices.fetchAuth(
      username: username,
      password: password,
    );
    signInResult.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (token) {
        state = state.copyWith(
          errorMessage: '',
          token: token.token,
          username: username,
          password: password,
        );
        _loadUserAndCart();
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> _loadUserAndCart() async {
    await keyValueStorageService.setKeyValue('token', state.token);
    if (state.token.isNotEmpty) {
      await ref
          .read(userInfoProvider.notifier)
          .fetchAllUsers(state.username, state.password);
    }
    if (ref.read(userInfoProvider).user != null) {
      await ref.read(cartProvider.notifier).fetchAllCarts();
    }
  }

  void logOutUser() async {
    state = state.copyWith(token: '', username: '', password: '');
    await keyValueStorageService.removeKey('token');
    ref.read(cartProvider.notifier).deleteUserCart();
    ref.read(userInfoProvider.notifier).logOutUser();
  }
}

final authenticationProvider = StateNotifierProvider.autoDispose<
  AuthenticationNotifier,
  AuthenticationApiResponse
>((ref) {
  final keyValueStorage = KeyValueStorage();

  return AuthenticationNotifier(
    ref,
    keyValueStorage,
  ); // Pasar el Ref al constructor
});
