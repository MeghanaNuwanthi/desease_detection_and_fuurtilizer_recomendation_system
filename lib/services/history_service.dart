// lib/services/history_service.dart
//
// Persists scan history using SQLite via the sqflite package.
//
// Add to pubspec.yaml:
//   dependencies:
//     sqflite: ^2.3.0
//     path: ^1.9.0
//
// Then run: flutter pub get
//
// Public API (saveEntry / getAllEntries / clearAll) is unchanged from the
// shared_preferences version, so scan_result_screen.dart and
// history_screen.dart don't need to know or care what's underneath.

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScanHistoryEntry {
  final int? id; // null until saved - SQLite assigns it on insert
  final String diseaseKey;
  final String confidencePercent;
  final String imagePath;
  final DateTime scannedAt;

  ScanHistoryEntry({
    this.id,
    required this.diseaseKey,
    required this.confidencePercent,
    required this.imagePath,
    required this.scannedAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) "id": id,
    "disease_key": diseaseKey,
    "confidence_percent": confidencePercent,
    "image_path": imagePath,
    "scanned_at": scannedAt.toIso8601String(),
  };

  factory ScanHistoryEntry.fromMap(Map<String, dynamic> map) {
    return ScanHistoryEntry(
      id: map["id"] as int?,
      diseaseKey: map["disease_key"] as String,
      confidencePercent: map["confidence_percent"] as String,
      imagePath: map["image_path"] as String,
      scannedAt: DateTime.parse(map["scanned_at"] as String),
    );
  }
}

class HistoryService {
  HistoryService._internal();
  static final HistoryService instance = HistoryService._internal();

  static const String _tableName = "scan_history";
  static const String _dbName = "paddyguard.db";

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _dbName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            disease_key TEXT NOT NULL,
            confidence_percent TEXT NOT NULL,
            image_path TEXT NOT NULL,
            scanned_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> saveEntry(ScanHistoryEntry entry) async {
    final db = await _database;
    await db.insert(_tableName, entry.toMap());
  }

  /// Most recent scans first.
  Future<List<ScanHistoryEntry>> getAllEntries() async {
    final db = await _database;
    final maps = await db.query(_tableName, orderBy: "scanned_at DESC");
    return maps.map((m) => ScanHistoryEntry.fromMap(m)).toList();
  }

  Future<void> deleteEntry(int id) async {
    final db = await _database;
    await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _database;
    await db.delete(_tableName);
  }
}
