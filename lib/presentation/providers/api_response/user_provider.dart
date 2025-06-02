import 'package:collection/collection.dart';
import 'package:fake_store/domain/models/user.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infraestructure/helppers/users/users_mapper.dart';

class UserApiResponse {
  final bool isLoading; // Indicates whether user data is currently being loaded
  final String?
  errorMessage; // Holds an error message if login fails or API fails
  final User? user; // The currently logged-in user (null if not logged in)

  UserApiResponse({this.user, this.isLoading = false, this.errorMessage});

  // Allows creating a new state object with modified fields
  UserApiResponse copyWith({
    bool? isLoading,
    String? errorMessage,
    Object? user = _sentinel,
  }) {
    return UserApiResponse(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user == _sentinel ? this.user : user as User?,
    );
  }

  static const _sentinel =
      Object(); // Used to distinguish between null and unmodified values
}

class UserNotifier extends StateNotifier<UserApiResponse> {
  final Ref ref; // Allows reading other providers (e.g. shared state)
  final ApiServices apiServices; // API service used to fetch user data

  UserNotifier(this.ref, this.apiServices) : super(UserApiResponse());

  // Attempts to log in a user by username and password
  Future<void> fetchAllUsers(String username, String password) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: '',
    ); // Show loading state

    final userResult = await apiServices.fetchUsers(); // Fetch users from API

    userResult.fold(
      // If failure, show error message and stop loading
      (failure) =>
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),

      // If success, try to find a user matching the username and password
      (users) {
        final loggedInUser = users.firstWhereOrNull(
          (user) => user.username == username && user.password == password,
        );

        // If user is found, update state with the logged-in user
        (loggedInUser != null)
            ? state = state.copyWith(
              isLoading: false,
              errorMessage: '',
              user: UsersMapper.userFakeStoreToUser(loggedInUser),
            )
            // If not found, show "User not found" error
            : state = state.copyWith(
              isLoading: false,
              errorMessage: 'User not found',
            );
      },
    );
  }

  // Logs out the current user by setting `user` to null
  void logOutUser() {
    state = state.copyWith(user: null);
  }
}

// Exposes the UserNotifier and its state for use in the UI
final userInfoProvider = StateNotifierProvider<UserNotifier, UserApiResponse>((
  ref,
) {
  return UserNotifier(ref, ApiServices());
});
