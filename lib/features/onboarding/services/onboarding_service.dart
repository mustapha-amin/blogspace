import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingStorageService {
  static const _keyOnboardingPassed = 'onboarding_passed';
  final FlutterSecureStorage _storage;

  OnboardingStorageService(this._storage);

  Future<void> saveOnboardingPassed(bool passed) async {
    await _storage.write(key: _keyOnboardingPassed, value: passed.toString());
  }

  Future<bool> isOnboardingPassed() async {
    final value = await _storage.read(key: _keyOnboardingPassed);
    return value == 'true';
  }

  Future<void> clearOnboardingState() async {
    await _storage.delete(key: _keyOnboardingPassed);
  }
}
