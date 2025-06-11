// controllers/MonAnController.dart

import '../database/DatabaseHelper.dart';
import '../models/MonAn.dart';

class MonAnController {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;

  Future<List<MonAn>> fetchAllMonAn() async {
    final db = await _dbHelper.database;
    final monAnMaps = await db.query('mon_an');
    return monAnMaps.map((map) => MonAn.fromMap(map)).toList();
  }

  Future<void> addMonAn(MonAn monAn) async {
    final db = await _dbHelper.database;
    await db.insert('mon_an', monAn.toMap());
  }

  Future<void> updateCurrentMonAn(MonAn monAn) async {
    final db = await _dbHelper.database;
    await db.update(
      'mon_an',
      monAn.toMap(),
      where: 'ma_mon = ?',
      whereArgs: [monAn.maMon],
    );
  }

  Future<void> deleteMonAn(String maMon) async {
    final db = await _dbHelper.database;
    await db.delete('mon_an', where: 'ma_mon = ?', whereArgs: [maMon]);
  }

  // Future<List<MonAn>> fetchAllMonAn() async {
  //   return await _dbHelper.getAllMonAn();
  // }

  Future<MonAn?> fetchMonAnDetail(String maMon) async {
    return await _dbHelper.getMonAn(maMon);
  }

  Future<List<MonAn>> fetchMonAnCungLoai(
    String maLoai,
    String currentMaMon,
  ) async {
    final List<MonAn> allMonAn = await _dbHelper.getAllMonAn2();
    return allMonAn
        .where((mon) => mon.maLoai == maLoai && mon.maMon != currentMaMon)
        .toList();
  }

  // Thêm các phương thức khác liên quan đến quản lý món ăn (ví dụ: thêm, sửa, xóa)
}
