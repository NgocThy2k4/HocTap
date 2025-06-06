// controllers/MonAnController.dart

import '../database/DatabaseHelper.dart';
import '../models/MonAn.dart';

class MonAnController {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;

  Future<List<MonAn>> fetchAllMonAn() async {
    return await _dbHelper.getAllMonAn();
  }

  Future<MonAn?> fetchMonAnDetail(String maMon) async {
    return await _dbHelper.getMonAn(maMon);
  }

  Future<List<MonAn>> fetchMonAnCungLoai(
    String maLoai,
    String currentMaMon,
  ) async {
    final List<MonAn> allMonAn = await _dbHelper.getAllMonAn();
    return allMonAn
        .where((mon) => mon.maLoai == maLoai && mon.maMon != currentMaMon)
        .toList();
  }

  // Thêm các phương thức khác liên quan đến quản lý món ăn (ví dụ: thêm, sửa, xóa)
}
