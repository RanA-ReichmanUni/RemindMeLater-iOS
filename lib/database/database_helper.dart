import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/reminder.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reminders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        timeframe TEXT NOT NULL,
        scheduledAt INTEGER NOT NULL,
        status TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.insert('reminders', reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Reminder?> getReminderById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'reminders',
      columns: ['id', 'text', 'timeframe', 'scheduledAt', 'status', 'createdAt'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reminder.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Reminder>> getActiveReminders() async {
    final db = await instance.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final result = await db.query(
      'reminders',
      where: "(status = 'PENDING' OR status = 'SNOOZED') AND scheduledAt > ?",
      whereArgs: [now],
      orderBy: 'scheduledAt ASC',
    );
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  /// Returns reminders that have already fired (past scheduledAt) but
  /// the user has not yet marked them as handled.
  Future<List<Reminder>> getFiredReminders() async {
    final db = await instance.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final result = await db.query(
      'reminders',
      where: "status = 'PENDING' AND scheduledAt <= ?",
      whereArgs: [now],
      orderBy: 'scheduledAt ASC',
    );
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await instance.database;
    final result = await db.query('reminders', orderBy: 'scheduledAt ASC');
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> updateReminderStatus(int id, ReminderStatus status) async {
    final db = await instance.database;
    return await db.update(
      'reminders',
      {'status': status.toDbValue()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
