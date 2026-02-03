import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageProvider {
  final storage = FlutterSecureStorage();

  Future<void> _deleteFromStorage(String key) async {
    await storage.delete(key: key);
  }

  Future<void> deleteUserFromStorage() async {
    _deleteFromStorage('email');
    _deleteFromStorage('password');
  }

  Future<void> _writeToStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<void> storeUserInStorage(String email, String password) async {
    _writeToStorage('email', email);
    _writeToStorage('password', password);
  }

  Future<String?> _readFromStorage(String key) async {
    return await storage.read(key: key);
  }

  Future<(String, String)> readUserFromStorage() async {
    final email = await _readFromStorage('email');
    final password = await _readFromStorage('password');
    return (email as String, password as String);
  }
}
