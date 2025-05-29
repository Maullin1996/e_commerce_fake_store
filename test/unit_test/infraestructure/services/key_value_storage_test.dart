import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_test.mocks.dart';

@GenerateMocks([SharedPreferences])
// Extends KeyValueStorage
class TestableKeyValueStorage extends KeyValueStorage {
  final SharedPreferences mockPrefs;

  TestableKeyValueStorage(this.mockPrefs);

  @override
  Future<SharedPreferences> getSharedPrefs() async {
    return mockPrefs;
  }
}

void main() {
  group('KeyValueStorage Tests', () {
    late MockSharedPreferences mockPrefs;
    late TestableKeyValueStorage storage;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      storage = TestableKeyValueStorage(mockPrefs);
    });
    group('getValue', () {
      test('should return int value when exists', () async {
        // Arrange
        const key = 'test_int';
        const expectedValue = 42;
        when(mockPrefs.getInt(key)).thenReturn(expectedValue);

        // Act
        final result = await storage.getValue<int>(key);

        // Assert
        expect(result, equals(expectedValue));
        verify(mockPrefs.getInt(key)).called(1);
      });
      test('should return null when int value does not exist', () async {
        // Arrange
        const key = 'nonexistent_int';
        when(mockPrefs.getInt(key)).thenReturn(null);

        // Act
        final result = await storage.getValue<int>(key);

        // Assert
        expect(result, isNull);
        verify(mockPrefs.getInt(key)).called(1);
      });

      test('should return String value when exists', () async {
        // Arrange
        const key = 'test_string';
        const expectedValue = 'hello world';
        when(mockPrefs.getString(key)).thenReturn(expectedValue);

        // Act
        final result = await storage.getValue<String>(key);

        // Assert
        expect(result, equals(expectedValue));
        verify(mockPrefs.getString(key)).called(1);
      });

      test('should return bool value when exists', () async {
        // Arrange
        const key = 'test_bool';
        const expectedValue = true;
        when(mockPrefs.getBool(key)).thenReturn(expectedValue);

        // Act
        final result = await storage.getValue<bool>(key);

        // Assert
        expect(result, equals(expectedValue));
        verify(mockPrefs.getBool(key)).called(1);
      });

      test('should return double value when exists', () async {
        // Arrange
        const key = 'test_double';
        const expectedValue = 3.14;
        when(mockPrefs.getDouble(key)).thenReturn(expectedValue);

        // Act
        final result = await storage.getValue<double>(key);

        // Assert
        expect(result, equals(expectedValue));
        verify(mockPrefs.getDouble(key)).called(1);
      });

      test('should return List<String> value when exists', () async {
        // Arrange
        const key = 'test_list';
        const expectedValue = ['item1', 'item2', 'item3'];
        when(mockPrefs.getStringList(key)).thenReturn(expectedValue);

        // Act
        final result = await storage.getValue<List<String>>(key);

        // Assert
        expect(result, equals(expectedValue));
        verify(mockPrefs.getStringList(key)).called(1);
      });
      test('should throw UnsupportedError for unsupported types', () {
        // Arrange
        const key = 'test_unsupported';

        // Act & Assert
        expect(
          () => storage.getValue<Map<String, dynamic>>(key),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });
    group('setKeyValue', () {
      test('should set int value successfully', () async {
        // Arrange
        const key = 'test_int';
        const value = 42;
        when(mockPrefs.setInt(key, value)).thenAnswer((_) async => true);

        // Act
        await storage.setKeyValue(key, value);

        // Assert
        verify(mockPrefs.setInt(key, value)).called(1);
      });

      test('should set String value successfully', () async {
        // Arrange
        const key = 'test_string';
        const value = 'hello world';
        when(mockPrefs.setString(key, value)).thenAnswer((_) async => true);

        // Act
        await storage.setKeyValue(key, value);

        // Assert
        verify(mockPrefs.setString(key, value)).called(1);
      });

      test('should set bool value successfully', () async {
        // Arrange
        const key = 'test_bool';
        const value = true;
        when(mockPrefs.setBool(key, value)).thenAnswer((_) async => true);

        // Act
        await storage.setKeyValue(key, value);

        // Assert
        verify(mockPrefs.setBool(key, value)).called(1);
      });

      test('should set double value successfully', () async {
        // Arrange
        const key = 'test_double';
        const value = 3.14;
        when(mockPrefs.setDouble(key, value)).thenAnswer((_) async => true);

        // Act
        await storage.setKeyValue(key, value);

        // Assert
        verify(mockPrefs.setDouble(key, value)).called(1);
      });

      test('should set List<String> value successfully', () async {
        // Arrange
        const key = 'test_list';
        const value = ['item1', 'item2', 'item3'];
        when(mockPrefs.setStringList(key, value)).thenAnswer((_) async => true);

        // Act
        await storage.setKeyValue(key, value);

        // Assert
        verify(mockPrefs.setStringList(key, value)).called(1);
      });

      test('should throw UnsupportedError for unsupported types', () {
        // Arrange
        const key = 'test_unsupported';
        final value = {'key': 'value'};

        // Act & Assert
        expect(
          () => storage.setKeyValue(key, value),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('removeKey', () {
      test('should remove key successfully and return true', () async {
        // Arrange
        const key = 'test_key';
        when(mockPrefs.remove(key)).thenAnswer((_) async => true);

        // Act
        final result = await storage.removeKey(key);

        // Assert
        expect(result, isTrue);
        verify(mockPrefs.remove(key)).called(1);
      });

      test('should return false when key removal fails', () async {
        // Arrange
        const key = 'test_key';
        when(mockPrefs.remove(key)).thenAnswer((_) async => false);

        // Act
        final result = await storage.removeKey(key);

        // Assert
        expect(result, isFalse);
        verify(mockPrefs.remove(key)).called(1);
      });
    });
  });
}
