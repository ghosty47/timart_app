import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create a database instance with name products
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''CREATE TABLE  products(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT NOT NULL,
      quantity TEXT NOT NULL,
      costprice TEXT NOT NULL,
      sellingprice TEXT NOT NULL,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    ''');
  }

  // This is the method calling createTables declared above
  static Future<sql.Database> db() async {
    return sql.openDatabase('timart.db', version: 1, onCreate: (
      sql.Database database,
      int version,
    ) async {
      await createTables(database);
    });
  }

  //Add new products
  static Future<int> addProduct(
    String name,
    String quantity,
    String costprice,
    String sellingprice,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'quantity': quantity,
      'costprice': costprice,
      'sellingprice': sellingprice,
    };

    final id = await db.insert(
      'products',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  // Get all products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await SQLHelper.db();
    return db.query('products', orderBy: 'id');
  }

  //Get a single product
  static Future<List<Map<String, dynamic>>> getProduct(int id) async {
    final db = await SQLHelper.db();
    return db.query(
      'products',
      where: 'id = ?',
      whereArgs: [
        id
      ],
      limit: 1,
    );
  }

  //Update a product
  static Future<int> updateProduct(
    int id,
    String name,
    String quantity,
    String costprice,
    String sellingprice,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'quantity': quantity,
      'costprice': costprice,
      'sellingprice': sellingprice,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('products', data, where: 'id = ?', whereArgs: [
      id
    ]);
    return result;
  }

  //Delete a product
  static Future<void> deleteProduct(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('products', where: 'id = ?', whereArgs: [
        id
      ]);
    } catch (e) {
      debugPrint('Trouble deleting this product: $e');
    }
  }
}
