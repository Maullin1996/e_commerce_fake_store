// Mocks generated by Mockito 5.4.5 from annotations
// in fake_store/test/widget_test/presentation/pages/home_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:fake_store/domain/services/key_value_storage_service.dart'
    as _i7;
import 'package:fake_store_api_package/errors/index_errors.dart' as _i5;
import 'package:fake_store_api_package/infraestructure/helpers/mappers.dart'
    as _i6;
import 'package:fake_store_api_package/methods/api_services.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ApiServices].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiServices extends _i1.Mock implements _i3.ApiServices {
  MockApiServices() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<
      _i2.Either<_i5.Failure, List<_i6.ProductsFakeStore>>> fetchProducts(
          {String? category}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchProducts,
          [],
          {#category: category},
        ),
        returnValue: _i4
            .Future<_i2.Either<_i5.Failure, List<_i6.ProductsFakeStore>>>.value(
            _FakeEither_0<_i5.Failure, List<_i6.ProductsFakeStore>>(
          this,
          Invocation.method(
            #fetchProducts,
            [],
            {#category: category},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.ProductsFakeStore>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.CartsFakeStore>>> fetchCarts() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchCarts,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.CartsFakeStore>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.CartsFakeStore>>(
          this,
          Invocation.method(
            #fetchCarts,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.CartsFakeStore>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.UsersFakeStore>>> fetchUsers() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUsers,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.UsersFakeStore>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.UsersFakeStore>>(
          this,
          Invocation.method(
            #fetchUsers,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.UsersFakeStore>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.TokenFakeStore>> fetchAuth({
    required String? username,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAuth,
          [],
          {
            #username: username,
            #password: password,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.TokenFakeStore>>.value(
                _FakeEither_0<_i5.Failure, _i6.TokenFakeStore>(
          this,
          Invocation.method(
            #fetchAuth,
            [],
            {
              #username: username,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.TokenFakeStore>>);
}

/// A class which mocks [KeyValueStorageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockKeyValueStorageService extends _i1.Mock
    implements _i7.KeyValueStorageService {
  MockKeyValueStorageService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> setKeyValue<T>(
    String? key,
    T? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setKeyValue,
          [
            key,
            value,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<T?> getValue<T>(String? key) => (super.noSuchMethod(
        Invocation.method(
          #getValue,
          [key],
        ),
        returnValue: _i4.Future<T?>.value(),
      ) as _i4.Future<T?>);

  @override
  _i4.Future<bool> removeKey(String? key) => (super.noSuchMethod(
        Invocation.method(
          #removeKey,
          [key],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
