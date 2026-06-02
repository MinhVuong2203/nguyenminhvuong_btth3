import 'package:nguyenminhvuong_btth3/data/models/profile_entry.dart';
import 'package:nguyenminhvuong_btth3/data/services/profile_database.dart';

class ProfileRepository {
  final ProfileDatabase _database;

  ProfileRepository({ProfileDatabase? database})
    : _database = database ?? ProfileDatabase.instance;

  Future<List<ProfileEntry>> getProfileEntries() {
    return _database.getEntries();
  }

  Future<void> saveProfileEntry(ProfileEntry entry) {
    return _database.saveEntry(entry);
  }

  Future<void> deleteProfileEntry(ProfileEntry entry) async {
    final id = entry.id;
    if (id == null) {
      return;
    }
    await _database.deleteEntry(id);
  }
}
