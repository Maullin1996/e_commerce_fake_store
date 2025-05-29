import 'package:fake_store/domain/models/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth', () {
    test('should create an instance with the correct token', () {
      // Arrange
      const token = '123abcToken';

      // Act
      final auth = Auth(token: token);

      // Assert
      expect(auth.token, equals(token));
    });

    test('copyWith should return a new instance with the updated token', () {
      // Arrange
      final original = Auth(token: 'originalToken');

      // Act
      final modified = original.copyWith(token: 'newToken');

      // Assert
      expect(modified.token, equals('newToken'));
      expect(
        original.token,
        equals('originalToken'),
      ); // original remains unchanged
    });

    test('copyWith with no parameters should retain the original token', () {
      // Arrange
      final auth = Auth(token: 'stayTheSame');

      // Act
      final copy = auth.copyWith();

      // Assert
      expect(copy.token, equals(auth.token));
    });
  });
}
