/// A class that represents a user entity.
class User {
  /// The address of the user.
  final Address address;

  /// The unique identifier of the user.
  final int id;

  /// The email of the user.
  final String email;

  /// The username of the user.
  final String username;

  /// The password of the user.
  final String password;

  /// The name of the user.
  final Name name;

  /// The phone number of the user.
  final String phone;

  /// Creates a [User] instance with the given [address], [id], [email], [username], [password], [name], and [phone].
  const User({
    required this.address,
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
  });

  /// Creates a copy of this [User] instance with the given fields replaced
  /// by new values.
  User copyWith({
    Address? address,
    int? id,
    String? email,
    String? username,
    String? password,
    Name? name,
    String? phone,
  }) {
    return User(
      address: address ?? this.address,
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}

/// A class that represents an address entity.
class Address {
  /// The city of the address.
  final String city;

  /// The street of the address.
  final String street;

  /// The number of the address.
  final int number;

  /// The zipcode of the address.
  final String zipcode;

  /// Creates an [Address] instance with the given [city], [street], [number], and [zipcode].
  const Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  /// Creates a copy of this [Address] instance with the given fields replaced
  /// by new values.
  Address copyWith({
    String? city,
    String? street,
    int? number,
    String? zipcode,
  }) {
    return Address(
      city: city ?? this.city,
      street: street ?? this.street,
      number: number ?? this.number,
      zipcode: zipcode ?? this.zipcode,
    );
  }
}

/// A class that represents a name entity.
class Name {
  /// The first name.
  final String firstname;

  /// The last name.
  final String lastname;

  /// Creates a [Name] instance with the given [firstname] and [lastname].
  const Name({required this.firstname, required this.lastname});

  /// Creates a copy of this [Name] instance with the given fields replaced
  /// by new values.
  Name copyWith({String? firstname, String? lastname}) {
    return Name(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
    );
  }
}
