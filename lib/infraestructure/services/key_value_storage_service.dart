abstract class KeyValueStorageService {
  Future<void> setKeyValue(String key, value);
  Future getValue(String key, value);
  Future<bool> removeKey(String key);
}
