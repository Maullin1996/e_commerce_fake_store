import 'package:fake_store/presentation/providers/shared/favorite_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/business_rules_mock.dart';

void main() {
  late ProviderContainer container;
  group('group name', () {
    setUp(() {
      container = ProviderContainer(
        overrides: [
          myFavoriteListProvider.overrideWith(
            (ref) => FavoriteListProvider([]),
          ),
        ],
      );
      addTearDown(container.dispose);
    });
    test('Should add to the favorite if the product is no in the list', () {
      // Act
      container
          .read(myFavoriteListProvider.notifier)
          .toggleFavorite(BusinessRulesMock.mockProducts[1]);
      final state = container.read(myFavoriteListProvider);
      expect(state.contains(BusinessRulesMock.mockProducts[1]), isTrue);
    });
    test(
      'Should remove to the favorite if the product is already in the list',
      () {
        // Act
        for (var product in BusinessRulesMock.mockProducts) {
          container
              .read(myFavoriteListProvider.notifier)
              .toggleFavorite(product);
        }
        final stateBefore = container.read(myFavoriteListProvider);
        expect(stateBefore.contains(BusinessRulesMock.mockProducts[1]), isTrue);
        container
            .read(myFavoriteListProvider.notifier)
            .toggleFavorite(BusinessRulesMock.mockProducts[1]);
        final stateAfter = container.read(myFavoriteListProvider);
        expect(stateAfter.contains(BusinessRulesMock.mockProducts[1]), isFalse);
      },
    );
    test('Return a boolean value if the product is or is not in the list', () {
      // Act
      container
          .read(myFavoriteListProvider.notifier)
          .toggleFavorite(BusinessRulesMock.mockProducts[4]);
      // Assert
      expect(
        container
            .read(myFavoriteListProvider.notifier)
            .isFavorite(BusinessRulesMock.mockProducts[4]),
        isTrue,
      );
      expect(
        container
            .read(myFavoriteListProvider.notifier)
            .isFavorite(BusinessRulesMock.mockProducts[1]),
        isFalse,
      );
    });
  });
}
