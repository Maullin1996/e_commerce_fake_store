// Abstract class defining a contract for key-value storage operations.
abstract class KeyValueStorageService {
  /// Stores a value of any type [T] under the specified [key].
  /// Overwrites the existing value if the key already exists.
  Future<void> setKeyValue<T>(String key, T value);

  /// Retrieves the value of type [T] associated with the given [key].
  /// Returns null if the key does not exist or if the value cannot be cast to [T].
  Future<T?> getValue<T>(String key);

  /// Removes the entry associated with the given [key].
  /// Returns `true` if the key was successfully removed, `false` otherwise.
  Future<bool> removeKey(String key);
}
