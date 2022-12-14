import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart';
import 'package:repo_viewer/auth/infrastructure/credential_storage/credential_storage.dart';

class SecureCredentialStorage implements CredentialStorage {
  final FlutterSecureStorage _storage;
  static const _key = 'oauth2_credentials';

  Credentials? _cachedCredentials;

  SecureCredentialStorage(this._storage);

  @override
  Future<Credentials?> read() async {
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    } else {
      final json = await _storage.read(key: _key);
      if (json == null) {
        return null;
      } else {
        try {
          return _cachedCredentials = Credentials.fromJson(json);
        } on FormatException {
          return null;
        }
      }
    }
  }

  @override
  Future<void> save(Credentials credentials) {
    _cachedCredentials = credentials;
    return _storage.write(key: _key, value: credentials.toJson());
  }

  @override
  Future<void> clear() {
    _cachedCredentials = null;
    return _storage.delete(key: _key);
  }
}
