import 'package:fake_store/domain/models.dart';
import 'package:fake_store/infraestructure/helppers/mappers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mocks_api.dart';

void main() {
  test('should map succefully ProductsFakeStore to Products', () {
    // Act
    final listOfUsers =
        MocksApi.userMock
            .map((user) => UsersMapper.userFakeStoreToUser(user))
            .toList();
    // Assert
    expect(listOfUsers, isA<List<User>>());
    expect(listOfUsers.length, 3);
    expect(listOfUsers[1].id, equals(2));
    expect(listOfUsers[1].address.city, equals('Chicago'));
    expect(listOfUsers[2].name.lastname, equals('Curry'));
    expect(listOfUsers[0].username, equals('kingjames'));
    expect(listOfUsers[0].email, equals('lebron.james@example.com'));
  });
}
