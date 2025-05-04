/// This class represents the authentication entity for the FakeStoreAPI.
/// It contains the authentication token returned by the API after a successful login.
class Auth {
  /// The authentication token used for authorized API requests.
  final String token;

  /// Constructor for creating an `Auth` instance.
  /// The `token` parameter is required to ensure the object is always initialized with a valid token.
  Auth({required this.token});

  /// Creates a copy of the current `Auth` instance with optional modifications.
  /// If a new `token` is provided, it will replace the existing one; otherwise, the current token is retained.
  Auth copyWith({String? token}) {
    return Auth(token: token ?? this.token);
  }
}
