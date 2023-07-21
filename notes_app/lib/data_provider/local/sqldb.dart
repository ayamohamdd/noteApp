import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqlDB{
  static Database? _dB;
  Future<Database?> get dB async{
    if(_dB==null){
      _dB = await initialDB();
    }
    return _dB;
  }
  initialDB() async{
    String databasePath = await getDatabasesPath();
    String dbName = 'notes.db';
    String path= join(databasePath,dbName);
    Database myDB = await openDatabase(path,onCreate: _onCreate,version: 2, onUpgrade: _onUpgrade
    );
    return myDB;
  }

  _onCreate(Database db, int version) async{
    await db.execute('''
        CREATE TABLE "notes"(
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
        "title" TEXT NOT NULL,
        "note" TEXT NOT NULL,
        "color" TEXT NOT NULL
        )
        ''');
    print("Create DB===========");
  }

  // To Drop Column color
  _onUpgrade(Database db,int oldVersion,int newVersion) async{
    // DOES NOT WORK!!
    // await db.execute('''
    // ALTER  TABLE notes
    // DROP color
    // ''');
    // Step 1: Create New Table
    await db.execute('''
      CREATE TABLE "new_notes" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "title" TEXT NOT NULL,
      "note" TEXT NOT NULL);
    ''');

    // Step 2:  Copy data from the old table to the new table
    await db.execute('''
      INSERT INTO new_notes (id, title, note)
      SELECT id,title,note FROM notes;
    ''');
    // Step 3: Drop the old table
    await db.execute('DROP TABLE notes;');

    // Step 4:  Rename the new table to the old table name
    await db.execute('ALTER TABLE new_notes RENAME TO notes;');
    print("Upgrade DB===========");
  }
  // SELECT
  readData(String sql) async{
    Database? myDB = await dB;
    List<Map> response = await myDB!.rawQuery(sql);
    return response;
  }
  // INSERT
  insertData(String sql) async{
    Database? myDB = await dB;
    int response = await myDB!.rawInsert(sql);
    return response;
  }
  // UPDATE
  updateData(String sql) async{
    Database? myDB = await dB;
    int response = await myDB!.rawUpdate(sql);
    return response;
  }
  // DELETE
  deleteData(String sql) async{
    Database? myDB = await dB;
    int response = await myDB!.rawDelete(sql);
    return response;
  }
  // Delete Database
  deleteDb() async{
    String databasePath = await getDatabasesPath();
    String dbName = 'notes.db';
    String path= join(databasePath,dbName);
    await deleteDatabase(path);
  }

  // SELECT
  read(String table) async{
    Database? myDB = await dB;
    List<Map> response = await myDB!.query(table);
    return response;
  }
  // INSERT
  insert(String table,Map<String,Object?> values) async{
    Database? myDB = await dB;
    int response = await myDB!.insert(table,values);
    return response;
  }
  // UPDATE
  update(String table, Map<String,Object?> values,String? myWhere) async{
    Database? myDB = await dB;
    int response = await myDB!.update(table,values, where: myWhere);
    return response;
  }
  // DELETE
  myDelete(String table, String? myWhere) async{
    Database? myDB = await dB;
    int response = await myDB!.delete("notes",where: myWhere);
    return response;
  }

}
