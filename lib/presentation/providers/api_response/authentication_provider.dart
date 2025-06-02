import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

// Class that represents the current state of the authentication process
class AuthenticationApiResponse {
  final bool isLoading; // True while the API request is being processed
  final String errorMessage; // Stores any error message from the API
  final String token; // JWT token returned from successful authentication
  final String username; // Username used to log in
  final String password; // Password used to log in

  AuthenticationApiResponse({
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage = '',
    this.token = '',
  });

  // Creates a new instance of the state with optional updated fields
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

// StateNotifier that manages authentication logic and state
class AuthenticationNotifier extends StateNotifier<AuthenticationApiResponse> {
  final Ref ref;
  final ApiServices apiServices;
  final KeyValueStorageService keyValueStorageService;

  // Constructor receives Ref for dependency access, storage, and API service
  AuthenticationNotifier(
    this.ref,
    this.keyValueStorageService,
    this.apiServices,
  ) : super(AuthenticationApiResponse());

  /// Handles user login by calling the API and updating the state accordingly
  Future<void> fetchAuthentication(String username, String password) async {
    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: '');

    // Call the API
    final signInResult = await apiServices.fetchAuth(
      username: username,
      password: password,
    );

    // Handle the result using fold (Either pattern from dartz)
    signInResult.fold(
      (failure) {
        // If error, update state with error message
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (token) {
        // If success, update state with token and user credentials
        state = state.copyWith(
          errorMessage: '',
          token: token.token,
          username: username,
          password: password,
        );
        // Load user and cart data
        _loadUserAndCart();
      },
    );
  }

  /// Loads user and cart data after a successful login
  Future<void> _loadUserAndCart() async {
    // Store token locally
    await keyValueStorageService.setKeyValue('token', state.token);

    // Load user info if token is valid
    if (state.token.isNotEmpty) {
      await ref
          .read(userInfoProvider.notifier)
          .fetchAllUsers(state.username, state.password);
    }

    // If user data is present, fetch cart data
    if (ref.read(userInfoProvider).user != null) {
      await ref.read(cartProvider.notifier).fetchAllCarts();
    }

    // End loading state
    state = state.copyWith(isLoading: false);
  }

  /// Clears authentication data and resets related state
  void logOutUser() async {
    // Reset authentication state
    state = state.copyWith(token: '', username: '', password: '');
    await keyValueStorageService.removeKey('token');

    // Clear user and cart providers
    ref.read(cartProvider.notifier).deleteUserCart();
    ref.read(userInfoProvider.notifier).logOutUser();
  }
}

// Provider that exposes the AuthenticationNotifier and its state
final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationApiResponse>((
      ref,
    ) {
      final keyValueStorage =
          KeyValueStorage(); // Uses SharedPreferences internally

      return AuthenticationNotifier(
        ref,
        keyValueStorage,
        ApiServices(), // Custom service that hits the FakeStoreAPI
      );
    });
