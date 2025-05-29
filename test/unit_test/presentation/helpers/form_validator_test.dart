import 'package:fake_store/presentation/helpers/form_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('checked the form validator returns', () {
    // Arrange
    const String emptyInput = '';
    const String toShort = '123';
    const String correctInput = '12345';
    // Act
    final resultEmpty = formValidator(emptyInput);
    final resultToShort = formValidator(toShort);
    final resultCorrectInput = formValidator(correctInput);
    // Assert
    expect(resultEmpty, equals('Empty filed'));
    expect(resultToShort, equals('User or password to short'));
    expect(resultCorrectInput, isNull);
  });
}
