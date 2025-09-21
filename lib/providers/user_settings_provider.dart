import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserSettingsService {
  final Box _box;
  UserSettingsService(this._box);

  String getUserName() {
    return _box.get('userName', defaultValue: 'Gamer');
  }

  Future<void> setUserName(String name) async {
    await _box.put('userName', name);
  }
}

final userSettingsServiceProvider = Provider<UserSettingsService>((ref) {
  final box = Hive.box('userSettings');
  return UserSettingsService(box);
});

final userNameProvider = StateProvider<String>((ref) {
  final settingsService = ref.watch(userSettingsServiceProvider);
  return settingsService.getUserName();
});