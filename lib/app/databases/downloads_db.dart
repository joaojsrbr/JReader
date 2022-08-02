import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DownloadsDB {
  DownloadsDB._();
  static final DownloadsDB db = DownloadsDB._();

  static String get table => 'downloads';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<List<Download>> get notFinished async {
    final Database db = await database;

    final List<Map<String, Object?>> results = await db.query(
      table,
      where: 'status = ?',
      whereArgs: [DownloadStatus.downloading.value],
    );

    return _resultsToDownload(results);
  }

  Future<List<Download>> allByBookId(String bookId) async {
    final Database db = await database;

    final List<Map<String, Object?>> results = await db.query(
      table,
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    return _resultsToDownload(results);
  }

  Future<int> update(Download data) async {
    final Database db = await database;

    return await db.update(
      table,
      data.toMap,
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Download> insert(String bookId, Chapter chapter) async {
    final Database db = await database;
    final Download item = Download(
      bookId: bookId,
      chapterId: chapter.id,
      content: [],
      contentUrl: chapter.url,
      status: DownloadStatus.downloading,
    );

    await db.insert(
      table,
      {'id': item.id, ...item.toMap},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return item;
  }

  Future<void> insertMany(String bookId, List<Chapter> chapters) async {
    final Database db = await database;
    final Batch batch = db.batch();

    for (Chapter chapter in chapters) {
      final Download item = Download(
        bookId: bookId,
        chapterId: chapter.id,
        content: [],
        contentUrl: chapter.url,
        status: DownloadStatus.downloading,
      );

      batch.insert(
        table,
        {'id': item.id, ...item.toMap},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit(noResult: true, continueOnError: true);
  }

  Future<int> remove(String id) async {
    final Database db = await database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Database> _initDB() async {
    final String databasesPath = await getDatabasesPath();
    final String databasePath = join(databasesPath, 'downloads.db');

    return await openDatabase(databasePath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
    CREATE TABLE IF NOT EXISTS $table (
      id TEXT PRIMARY KEY UNIQUE NOT NULL,
      bookId TEXT NOT NULL,
      chapterId TEXT NOT NULL,
      content TEXT NOT NULL,
      contentUrl TEXT NOT NULL,
      status TEXT NOT NULL
    );
    ''');
  }

  List<Download> _resultsToDownload(List<Map<String, Object?>> results) {
    return results.map((e) {
      return Download(
        bookId: e['bookId'] as String,
        chapterId: e['chapterId'] as String,
        content: Download.contentList(e['content'] as String),
        contentUrl: e['contentUrl'] as String,
        status: _convertToStatus(e['status'] as String),
      );
    }).toList();
  }

  DownloadStatus _convertToStatus(String value) {
    if (value == DownloadStatus.finished.value) return DownloadStatus.finished;
    return DownloadStatus.downloading;
  }
}
