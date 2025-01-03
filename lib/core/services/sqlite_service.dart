
// Import necessary packages for SQLite database operations
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry_model.dart';

// Service class for managing SQLite database operations
class SQLiteService {
  Database? _database; // Private variable to hold the database instance

  // Setter for the database instance
  set database(Database? db) {
    _database = db;
  }

  // Method to initialize the database
  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'journal.db'), // Path for the database
      onCreate: (db, version) {
        // Create the journal_entries table
        return db.execute(
          'CREATE TABLE journal_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, mood TEXT, date TEXT)',
        );
      },
      version: 1, // Database version
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle database upgrade logic here
      },
    );
  }

  // Method to save a journal entry to the database
  Future<void> saveJournalEntry(JournalEntry entry) async {
    try {
      await _checkDatabase(); // Ensure the database is initialized
      if (entry.id == null) {
        // Insert new entry if it doesn't have an ID
        await _database!.insert(
          'journal_entries',
          entry.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        // Update existing entry if it has an ID
        await _database!.update(
          'journal_entries',
          entry.toJson(),
          where: 'id = ?',
          whereArgs: [entry.id],
        );
      }
    } catch (e) {
      print("Error saving journal entry: $e"); // Log any errors
    }
  }

  // Method to retrieve all journal entries from the database
  Future<List<JournalEntry>> getJournalEntries() async {
    try {
      await _checkDatabase(); // Ensure the database is initialized
      final List<Map<String, dynamic>> maps =
          await _database!.query('journal_entries'); // Query the entries
      return List.generate(maps.length, (i) {
        return JournalEntry.fromJson(
            maps[i]); // Convert maps to JournalEntry objects
      });
    } catch (e) {
      print("Error retrieving journal entries: $e"); // Log any errors
      return []; // Return an empty list on error
    }
  }

  // Method to delete a journal entry by ID
  Future<void> deleteJournalEntry(int id) async {
    try {
      await _checkDatabase(); // Ensure the database is initialized
      await _database!.delete(
        'journal_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting journal entry: $e"); // Log any errors
    }
  }

  // Method to close the database connection
  Future<void> closeDatabase() async {
    await _database?.close(); // Close the database if it's open
    _database = null; // Set the database instance to null
  }

  // Private method to check if the database is initialized
  Future<void> _checkDatabase() async {
    if (_database == null) {
      throw Exception(
          "Database not initialized. Call init() first."); // Throw an exception if not initialized
    }
  }
}
