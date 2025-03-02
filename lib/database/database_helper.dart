import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:nursesync/models/patient.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nursesync.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE patients (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          vitalSigns TEXT,
          tasks TEXT
        )
      ''');
    });
  }

  Future<int> insertPatient(Patient patient) async {
    Database db = await database;
    return await db.insert('patients', patient.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Patient>> getAllPatients() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('patients');
    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  Future<Patient> getPatientById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('patients', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Patient.fromMap(maps.first);
    return null;
  }

  Future<int> updatePatient(Patient patient) async {
    Database db = await database;
    return await db.update('patients', patient.toMap(), where: 'id = ?', whereArgs: [patient.id]);
  }

  Future<int> deletePatient(int id) async {
    Database db = await database;
    return await db.delete('patients', where: 'id = ?', whereArgs: [id]);
  }
}
