// database/DatabaseHelper.dart (CẬP NHẬT)

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'InsertData.dart'; // Đường dẫn đúng
import '../models/MonAn.dart';
import '../models/LoaiMonAn.dart';
import '../models/NhanVien.dart'; // Import model mới
import '../models/KhachHang.dart'; // Import model mới
import '../models/User.dart'; // Import User model

class QLQuanAnDatabaseHelper {
  static final QLQuanAnDatabaseHelper instance =
      QLQuanAnDatabaseHelper._privateConstructor();
  static Database? _database;

  QLQuanAnDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(
      await getDatabasesPath(),
      'ql_quan_an_final.db',
    ); // Đổi tên DB để đảm bảo tạo mới
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    // Bảng vai_tro
    await db.execute('''
      CREATE TABLE vai_tro (
        ma_vai_tro NVARCHAR(15) PRIMARY KEY,
        ten_vai_tro NVARCHAR(100) NOT NULL
      )
    ''');

    // Bảng nguoi_dung (Thêm cột ma_lien_quan để lưu mã nhân viên/khách hàng)
    await db.execute('''
      CREATE TABLE nguoi_dung (
        ma_nguoi_dung NVARCHAR(15) NOT NULL PRIMARY KEY,
        ten_dang_nhap NVARCHAR(50) NOT NULL,
        mat_khau NVARCHAR(255) NOT NULL,
        email NVARCHAR(100) UNIQUE NOT NULL,
        ma_vai_tro NVARCHAR(15) NOT NULL,
        ma_lien_quan NVARCHAR(15), -- Thêm cột này để lưu ma_khach_hang hoặc ma_nhan_vien
        FOREIGN KEY (ma_vai_tro) REFERENCES vai_tro(ma_vai_tro)
      )
    ''');

    // Bảng nhan_vien (Đã có sẵn, không thay đổi)
    await db.execute('''
      CREATE TABLE nhan_vien (
        ma_nhan_vien NVARCHAR(15) NOT NULL PRIMARY KEY,
        ten_nhan_vien NVARCHAR(100),
        chuc_vu NVARCHAR(100),
        dia_chi NVARCHAR(100),
        dien_thoai NVARCHAR(100),
        hinh_anh NVARCHAR(100),
        ghi_chu NVARCHAR(500)
      )
    ''');

    // Bảng khach_hang (Đã có sẵn, không thay đổi)
    await db.execute('''
      CREATE TABLE khach_hang (
        ma_khach_hang NVARCHAR(15) NOT NULL PRIMARY KEY,
        ten_khach_hang NVARCHAR(100),
        dia_chi NVARCHAR(100),
        dien_thoai NVARCHAR(100),
        hinh_anh NVARCHAR(100),
        ghi_chu NVARCHAR(500)
      )
    ''');

    // Bảng loai_mon_an (Đã có sẵn, không thay đổi)
    await db.execute('''
      CREATE TABLE loai_mon_an (
        ma_loai NVARCHAR(15) NOT NULL PRIMARY KEY,
        ten_loai TEXT,
        mo_ta TEXT,
        hinh TEXT
      )
    ''');

    // Bảng mon_an (Đã có sẵn, không thay đổi)
    await db.execute('''
      CREATE TABLE mon_an (
        ma_mon NVARCHAR(15) NOT NULL PRIMARY KEY,
        ma_loai NVARCHAR(15) NOT NULL,
        ten_mon TEXT,
        noi_dung_tom_tat TEXT,
        noi_dung_chi_tiet TEXT,
        don_gia REAL,
        don_gia_khuyen_mai REAL,
        khuyen_mai TEXT,
        hinh TEXT,
        ngay_cap_nhat TEXT,
        dvt TEXT,
        trong_ngay INTEGER,
        FOREIGN KEY (ma_loai) REFERENCES loai_mon_an (ma_loai)
      )
    ''');

    // Bảng hoa_don (Đã có sẵn, không thay đổi)
    await db.execute('''
      CREATE TABLE hoa_don (
        ma_hoa_don NVARCHAR(15) NOT NULL PRIMARY KEY,
        ma_khach_hang NVARCHAR(15) NOT NULL,
        ma_nhan_vien NVARCHAR(15) NOT NULL,
        ngay_dat TEXT,
        tong_tien REAL,
        tien_dat_coc REAL,
        con_lai REAL,
        hinh_thuc_thanh_toan TEXT,
        ghi_chu TEXT,
        FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang (ma_khach_hang),
        FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien (ma_nhan_vien)
      )
    ''');

    // Bảng chi_tiet_hoa_don (Đã có sẵn, không thay đổi)
    await db.execute('''
      CREATE TABLE chi_tiet_hoa_don (
        ma_hoa_don NVARCHAR(15) NOT NULL,
        ma_mon NVARCHAR(15) NOT NULL,
        so_luong INTEGER,
        don_gia REAL,
        mon_thuc_don INTEGER NOT NULL,
        PRIMARY KEY (ma_hoa_don, ma_mon, mon_thuc_don),
        FOREIGN KEY (ma_hoa_don) REFERENCES hoa_don (ma_hoa_don),
        FOREIGN KEY (ma_mon) REFERENCES mon_an (ma_mon)
      )
    ''');

    // Chèn dữ liệu ban đầu sau khi tạo bảng
    await insertInitialData(db);
  }

  // Các phương thức CRUD cơ bản (ví dụ cho nguoi_dung)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('nguoi_dung');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'nguoi_dung',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getUserByMaNguoiDung(String maNguoiDung) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'nguoi_dung',
      where: 'ma_nguoi_dung = ?',
      whereArgs: [maNguoiDung],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'nguoi_dung',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertNhanVien(Map<String, dynamic> nhanVien) async {
    final db = await database;
    await db.insert(
      'nhan_vien',
      nhanVien,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertKhachHang(Map<String, dynamic> khachHang) async {
    final db = await database;
    await db.insert(
      'khach_hang',
      khachHang,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getNhanVienByMa(String maNhanVien) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'nhan_vien',
      where: 'ma_nhan_vien = ?',
      whereArgs: [maNhanVien],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> getNextMaNguoiDung(String prefix) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT ma_nguoi_dung FROM nguoi_dung WHERE ma_nguoi_dung LIKE '$prefix%' ORDER BY ma_nguoi_dung DESC LIMIT 1",
    );

    if (result.isNotEmpty) {
      String lastMa = result.first['ma_nguoi_dung'];
      int lastNumber = int.parse(lastMa.substring(prefix.length));
      return lastNumber + 1;
    } else {
      return 1;
    }
  }

  // Thêm vào QLQuanAnDatabaseHelper
  Future<void> updateKhachHang(Map<String, dynamic> khachHang) async {
    final db = await database;
    await db.update(
      'khach_hang',
      khachHang,
      where: 'ma_khach_hang = ?',
      whereArgs: [khachHang['ma_khach_hang']],
    );
  }

  Future<Map<String, dynamic>?> getKhachHangByMa(String maKhachHang) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'khach_hang',
      where: 'ma_khach_hang = ?',
      whereArgs: [maKhachHang],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateNhanVien(Map<String, dynamic> nhanVien) async {
    final db = await database;
    await db.update(
      'nhan_vien',
      nhanVien,
      where: 'ma_nhan_vien = ?',
      whereArgs: [nhanVien['ma_nhan_vien']],
    );
  }

  // Thêm các phương thức để lấy danh sách món ăn và chi tiết món ăn
  Future<List<MonAn>> getAllMonAn() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mon_an');

    return List.generate(maps.length, (i) {
      return MonAn.fromMap(maps[i]);
    });
  }

  Future<MonAn?> getMonAn(String maMon) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mon_an',
      where: 'ma_mon = ?',
      whereArgs: [maMon],
    );

    if (maps.isNotEmpty) {
      return MonAn.fromMap(maps.first);
    }
    return null;
  }

  // // Thêm vào AuthController:
  // void updateCurrentUser(User user) {
  //   _currentUser = user;
  //   notifyListeners();
  // }
}
