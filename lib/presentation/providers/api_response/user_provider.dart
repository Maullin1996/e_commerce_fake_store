import 'package:collection/collection.dart';
import 'package:fake_store/domain/models/user.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infraestructure/helppers/users/users_mapper.dart';

class UserApiResponse {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  UserApiResponse({this.user, this.isLoading = false, this.errorMessage});

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

  static const _sentinel = Object();
}

class UserNotifier extends StateNotifier<UserApiResponse> {
  final Ref ref;
  final ApiServices apiServices;

  UserNotifier(this.ref, this.apiServices) : super(UserApiResponse());

  Future<void> fetchAllUsers(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    final userResult = await apiServices.fetchUsers();
    userResult.fold(
      (failure) =>
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
      (users) {
        final loggedInUser = users.firstWhereOrNull(
          (user) => user.username == username && user.password == password,
        );
        (loggedInUser != null)
            ? state = state.copyWith(
              isLoading: false,
              errorMessage: '',
              user: UsersMapper.userFakeStoreToUser(loggedInUser),
            )
            : state = state.copyWith(
              isLoading: false,
              errorMessage: 'User not found',
            );
      },
    );
  }

  void logOutUser() {
    state = state.copyWith(user: null);
  }
}

final userInfoProvider = StateNotifierProvider<UserNotifier, UserApiResponse>((
  ref,
) {
  return UserNotifier(ref, ApiServices());
});
