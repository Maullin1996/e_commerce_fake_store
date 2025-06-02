import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Concrete implementation of KeyValueStorageService using SharedPreferences.
// Supports storing and retrieving common data types locally.
class KeyValueStorage extends KeyValueStorageService {
  /// Helper method to obtain the SharedPreferences instance asynchronously
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Retrieves a value of type [T] associated with the given [key].
  /// Supports int, String, bool, double, and List<String>.
  /// Returns `null` if the key doesn't exist.
  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    } else {
      // Throws an error if an unsupported type is requested
      throw UnsupportedError('get not implemented for type ${T.runtimeType}');
    }
  }

  /// Removes a stored key-value pair from SharedPreferences.
  /// Returns true if the key was found and successfully removed.
  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();

    return prefs.remove(key);
  }

  /// Stores a value of type [T] using the given [key].
  /// Supports int, String, bool, double, and List<String>.
  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      // Throws an error if an unsupported type is passed
      throw UnsupportedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}
