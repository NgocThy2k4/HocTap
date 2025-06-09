// database/DatabaseHelper.dart (CẬP NHẬT VÀ TỐI ƯU)

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
    // Tăng version để cơ sở dữ liệu được tạo lại HOẶC xóa ứng dụng thủ công
    return await openDatabase(path, version: 102, onCreate: _createDb);
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
        ten_dang_nhap NVARCHAR(50) NOT NULL UNIQUE,
        mat_khau NVARCHAR(255) NOT NULL, -- ĐẢM BẢO NOT NULL
        email NVARCHAR(100) UNIQUE NOT NULL,
        ma_vai_tro NVARCHAR(15) NOT NULL,
        ma_lien_quan NVARCHAR(15), -- Có thể NULL nếu muốn, nhưng hiện tại bạn đang gán giá trị
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

  // --- CÁC PHƯƠNG THỨC CRUD CHO nguoi_dung ---

  // Hàm insertUser: Chèn hoặc cập nhật người dùng (đã sửa để không loại bỏ mật khẩu)
  Future<int> insertUser(Map<String, dynamic> userMap) async {
    final db = await database;
    print('DBG: insertUser received map: $userMap'); // Log để kiểm tra input

    // Kiểm tra xem người dùng đã tồn tại bằng ma_nguoi_dung chưa
    List<Map<String, dynamic>> existingUser = await db.query(
      'nguoi_dung',
      where: 'ma_nguoi_dung = ?',
      whereArgs: [userMap['ma_nguoi_dung']],
    );

    if (existingUser.isNotEmpty) {
      // Nếu tồn tại, cập nhật bản ghi hiện có
      // Cập nhật toàn bộ userMap, bao gồm 'mat_khau'.
      print(
        'DBG: Updating existing user with ma_nguoi_dung: ${userMap['ma_nguoi_dung']}',
      );
      return await db.update(
        'nguoi_dung',
        userMap,
        where: 'ma_nguoi_dung = ?',
        whereArgs: [userMap['ma_nguoi_dung']],
      );
    } else {
      // Nếu chưa tồn tại, chèn bản ghi mới
      print(
        'DBG: Inserting new user with ma_nguoi_dung: ${userMap['ma_nguoi_dung']}',
      );
      return await db.insert('nguoi_dung', userMap);
    }
  }

  // Hàm updateUser: Dùng để cập nhật người dùng.
  // Hàm này sẽ cập nhật tất cả các trường trong `userMap` bao gồm cả `mat_khau` nếu có.
  Future<int> updateUser(Map<String, dynamic> userMap) async {
    final db = await database;
    String maNguoiDung = userMap['ma_nguoi_dung'];
    print(
      'DBG: updateUser received map: $userMap for ma_nguoi_dung: $maNguoiDung',
    );
    return await db.update(
      'nguoi_dung',
      userMap, // Cập nhật toàn bộ map được truyền vào
      where: 'ma_nguoi_dung = ?',
      whereArgs: [maNguoiDung],
    );
  }

  // Hàm updateNguoiDung: Đã điều chỉnh để không loại bỏ 'mat_khau'
  // Tuy nhiên, các trường 'ma_nguoi_dung', 'ma_vai_tro', 'ma_lien_quan' vẫn bị loại bỏ.
  // Vui lòng kiểm tra lại nếu bạn có ý định cập nhật các trường này thông qua hàm này.
  Future<int> updateNguoiDung(Map<String, dynamic> userMap) async {
    final db = await database;
    String maNguoiDung = userMap['ma_nguoi_dung'];

    Map<String, dynamic> updateValues = Map.from(userMap);

    // Dòng này đã được loại bỏ để cho phép cập nhật mật khẩu nếu được cung cấp
    // updateValues.remove('mat_khau');

    // Những dòng này cũng cần xem xét lại mục đích:
    updateValues.remove('ma_nguoi_dung'); // Không nên cập nhật khóa chính
    updateValues.remove('ma_vai_tro');
    updateValues.remove('ma_lien_quan');

    print(
      'DBG: updateNguoiDung update values: $updateValues for ma_nguoi_dung: $maNguoiDung',
    );
    return await db.update(
      'nguoi_dung',
      updateValues,
      where: 'ma_nguoi_dung = ?',
      whereArgs: [maNguoiDung],
    );
  }

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

  Future<Map<String, dynamic>?> getUserByUsername(String tenDangNhap) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'nguoi_dung',
      where: 'ten_dang_nhap = ?',
      whereArgs: [tenDangNhap],
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
    final List<Map<String, dynamic>> result = await db.query(
      'nguoi_dung',
      columns: ['ma_nguoi_dung'],
      where: 'ma_nguoi_dung LIKE ?',
      whereArgs: ['${prefix}%'],
      orderBy: 'ma_nguoi_dung DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final lastMaNguoiDung = result.first['ma_nguoi_dung'] as String;
      final lastNumberString = lastMaNguoiDung.replaceAll(prefix, '');
      final lastNumber = int.tryParse(lastNumberString);
      if (lastNumber != null) {
        return lastNumber + 1;
      }
    }
    return 1; // Bắt đầu từ 1 nếu không có
  }

  Future<void> updateKhachHang(Map<String, dynamic> khachHang) async {
    final db = await database;
    await db.update(
      'khach_hang',
      khachHang,
      where: 'ma_khach_hang = ?',
      whereArgs: [khachHang['ma_khach_hang']],
    );
  }

  Future<int> deleteKhachHang(String maKhachHang) async {
    final db = await database;
    print('DBG: Deleting KhachHang: $maKhachHang');
    return await db.delete(
      'khach_hang',
      where: 'ma_khach_hang = ?',
      whereArgs: [maKhachHang],
    );
  }

  Future<List<KhachHang>> getAllKhachHang() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('khach_hang');
    return List.generate(maps.length, (i) {
      return KhachHang.fromMap(maps[i]);
    });
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

  Future<int> deleteNhanVien(String maNhanVien) async {
    final db = await database;
    print('DBG: Deleting NhanVien: $maNhanVien');
    return await db.delete(
      'nhan_vien',
      where: 'ma_nhan_vien = ?',
      whereArgs: [maNhanVien],
    );
  }

  Future<List<NhanVien>> getAllNhanVien() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('nhan_vien');
    return List.generate(maps.length, (i) {
      return NhanVien.fromMap(maps[i]);
    });
  }

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

  Future<int> deleteMonAn(String maMon) async {
    final db = await database;
    print('DBG: Deleting MonAn: $maMon');
    return await db.delete('mon_an', where: 'ma_mon = ?', whereArgs: [maMon]);
  }
}
