import 'package:fake_store/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final address = Address(
    city: 'Springfield',
    street: 'Evergreen Terrace',
    number: 742,
    zipcode: '12345',
  );

  final name = Name(firstname: 'Homer', lastname: 'Simpson');

  final user = User(
    address: address,
    id: 1,
    email: 'homer@springfield.com',
    username: 'homers',
    password: 'donuts123',
    name: name,
    phone: '555-1234',
  );

  group('User', () {
    test('should create an instance with the correct parameters', () {
      //Assert
      expect(user.id, equals(1));
      expect(user.email, equals('homer@springfield.com'));
      expect(user.address.city, equals('Springfield'));
      expect(user.address.number, equals(742));
      expect(user.name.lastname, equals('Simpson'));
    });
    test('copyWith should override selected User fields', () {
      // Act
      final updatedUser = user.copyWith(
        email: 'newemail@springfield.com',
        phone: '555-0000',
      );
      // Assert
      expect(updatedUser.email, equals('newemail@springfield.com'));
      expect(updatedUser.phone, equals('555-0000'));

      // Unchanged values
      expect(updatedUser.username, equals('homers'));
      expect(updatedUser.id, equals(1));
      expect(updatedUser.name.firstname, equals('Homer'));
    });
    test('copyWith should override Address fields', () {
      final newAddress = address.copyWith(city: 'Shelbyville');
      expect(newAddress.city, equals('Shelbyville'));
      expect(newAddress.street, equals('Evergreen Terrace')); // unchanged
    });
    test('copyWith should override Name fields', () {
      final newName = name.copyWith(firstname: 'Bart');
      expect(newName.firstname, equals('Bart'));
      expect(newName.lastname, equals('Simpson')); // unchanged
    });
  });
}
