import 'package:fake_store/domain/models/user_entity.dart';
import 'package:fake_store_api_package/infraestructure/helppers/mappers.dart';

/// A mapper class for converting between [UsersFakeStore] and [User] entities.
class UsersMapper {
  /// Converts a [UsersFakeStore] instance to a [User] instance.
  ///
  /// Takes a [UsersFakeStore] object and maps its properties to create
  /// a new [User] object.
  static User userFakeStoreToUser(UsersFakeStore usersFakeStore) {
    return User(
      address: Address(
        city: usersFakeStore.apiAddress.city,
        street: usersFakeStore.apiAddress.street,
        number: usersFakeStore.apiAddress.number,
        zipcode: usersFakeStore.apiAddress.zipcode,
      ),
      id: usersFakeStore.id,
      email: usersFakeStore.email,
      username: usersFakeStore.username,
      password: usersFakeStore.password,
      name: Name(
        firstname: usersFakeStore.apiName.firstname,
        lastname: usersFakeStore.apiName.lastname,
      ),
      phone: usersFakeStore.phone,
    );
  }
}
