import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../mock/business_rules_mock.dart';
import 'has_cart_user_test.mocks.dart';

@GenerateMocks([ApiServices])
void main() {
  late ProviderContainer container;
  late MockApiServices mockApiServices;

  group('User and cart != null', () {
    setUp(() {
      mockApiServices = MockApiServices();
      container = ProviderContainer(
        overrides: [
          hasCartOrUser,
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          cartProvider.overrideWith(
            (ref) => CartNotifier(ref, mockApiServices)
              ..state = CartApiResponse(carts: BusinessRulesMock.mockCarts[0]),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('should return true', () {
      expect(container.read(hasCartOrUser), isTrue);
    });
  });

  group('User == null and cart != null', () {
    setUp(() {
      mockApiServices = MockApiServices();
      container = ProviderContainer(
        overrides: [
          hasCartOrUser,
          userInfoProvider.overrideWith(
            (ref) =>
                UserNotifier(ref, mockApiServices)
                  ..state = UserApiResponse(user: null),
          ),
          cartProvider.overrideWith(
            (ref) => CartNotifier(ref, mockApiServices)
              ..state = CartApiResponse(carts: BusinessRulesMock.mockCarts[0]),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('should return true', () {
      expect(container.read(hasCartOrUser), isTrue);
    });
  });
  group('User != null and cart == null', () {
    setUp(() {
      mockApiServices = MockApiServices();
      container = ProviderContainer(
        overrides: [
          hasCartOrUser,
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          cartProvider.overrideWith(
            (ref) =>
                CartNotifier(ref, mockApiServices)
                  ..state = CartApiResponse(carts: null),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('should return true', () {
      expect(container.read(hasCartOrUser), isTrue);
    });
  });
  group('User == null and cart == null', () {
    setUp(() {
      mockApiServices = MockApiServices();
      container = ProviderContainer(
        overrides: [
          hasCartOrUser,
          userInfoProvider.overrideWith(
            (ref) =>
                UserNotifier(ref, mockApiServices)
                  ..state = UserApiResponse(user: null),
          ),
          cartProvider.overrideWith(
            (ref) =>
                CartNotifier(ref, mockApiServices)
                  ..state = CartApiResponse(carts: null),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('should return true', () {
      expect(container.read(hasCartOrUser), isFalse);
    });
  });
}
