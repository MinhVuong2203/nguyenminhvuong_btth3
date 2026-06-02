import 'package:nguyenminhvuong_btth3/data/models/profile_entry.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDatabase {
  static final ProfileDatabase instance = ProfileDatabase._();

  ProfileDatabase._();

  static const String _tableName = 'profile_entries';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    _database = await openDatabase(
      '$databasesPath/profile_entries.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            section TEXT NOT NULL,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            time TEXT NOT NULL,
            content TEXT NOT NULL,
            tags TEXT NOT NULL,
            fileName TEXT NOT NULL,
            fileInfo TEXT NOT NULL
          )
        ''');
        await _seed(db);
      },
    );

    return _database!;
  }

  Future<List<ProfileEntry>> getEntries() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'id ASC');
    return maps.map(ProfileEntry.fromMap).toList();
  }

  Future<int> insertEntry(ProfileEntry entry) async {
    final db = await database;
    return db.insert(_tableName, entry.toMap()..remove('id'));
  }

  Future<int> updateEntry(ProfileEntry entry) async {
    final db = await database;
    return db.update(
      _tableName,
      entry.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> saveEntry(ProfileEntry entry) async {
    if (entry.id == null) {
      await insertEntry(entry);
      return;
    }
    await updateEntry(entry);
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> _seed(Database db) async {
    final entries = [
      const ProfileEntry(
        section: 'about',
        title: 'About me',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lectus id commodo egestas metus interdum dolor.',
      ),
      const ProfileEntry(
        section: 'work',
        title: 'Manager',
        subtitle: 'Amazon Inc',
        time: 'Jan 2015 - Feb 2022 - 5 Years',
      ),
      const ProfileEntry(
        section: 'education',
        title: 'Information Technology',
        subtitle: 'University of Oxford',
        time: 'Sep 2010 - Aug 2013 - 5 Years',
      ),
      const ProfileEntry(
        section: 'skill',
        title: 'Skill',
        tags:
            'Leadership|Teamwork|Visioner|Target oriented|Consistent|Good communication skills|Responsibility',
      ),
      const ProfileEntry(
        section: 'language',
        title: 'Language',
        tags: 'English|German|Spanish|Mandarin|Italy',
      ),
      const ProfileEntry(
        section: 'appreciation',
        title: 'Wireless Symposium (RWS)',
        subtitle: 'Young Scientist',
        time: '2014',
      ),
      const ProfileEntry(
        section: 'resume',
        title: 'Resume',
        fileName: 'Jament kudasi - CV - UI/UX Designer',
        fileInfo: '867 Kb - 14 Feb 2022 at 11:30 am',
      ),
    ];

    for (final entry in entries) {
      await db.insert(_tableName, entry.toMap()..remove('id'));
    }
  }
}
