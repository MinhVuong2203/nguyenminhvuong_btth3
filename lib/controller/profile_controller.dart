import 'package:nguyenminhvuong_btth3/data/models/profile_entry.dart';
import 'package:nguyenminhvuong_btth3/data/repository/profile_repository.dart';

class ProfileController {
  final ProfileRepository _repository;

  ProfileController({ProfileRepository? repository})
    : _repository = repository ?? ProfileRepository();

  Future<List<ProfileEntry>> getEntries() {
    return _repository.getProfileEntries();
  }

  Future<void> saveEntry(ProfileEntry entry) {
    return _repository.saveProfileEntry(entry);
  }

  Future<void> deleteEntry(ProfileEntry entry) {
    return _repository.deleteProfileEntry(entry);
  }
}
