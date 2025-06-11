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
    return await openDatabase(path, version: 18, onCreate: _createDb);
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
    // Thêm 1 số bảng để lưu đơn hàng, chi tiết đơn hàng, v.v. nếu cần
    // Bảng orders để lưu đơn hàng
    await db.execute('''
      CREATE TABLE orders (
        ma_don_hang TEXT PRIMARY KEY,
        ma_khach_hang TEXT,
        tong_tien REAL NOT NULL,
        dia_chi_giao_hang TEXT,
        phuong_thuc_thanh_toan TEXT,
        trang_thai TEXT NOT NULL,
        ngay_dat TEXT NOT NULL,
        FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang(ma_khach_hang)
      )
    ''');

    // Bảng order_details để lưu chi tiết đơn hàng
    await db.execute('''
      CREATE TABLE order_details (
        ma_don_hang TEXT,
        ma_mon TEXT,
        so_luong INTEGER NOT NULL,
        don_gia REAL NOT NULL,
        PRIMARY KEY (ma_don_hang, ma_mon),
        FOREIGN KEY (ma_don_hang) REFERENCES orders(ma_don_hang),
        FOREIGN KEY (ma_mon) REFERENCES mon_an(ma_mon)
      )
    ''');

    // Bảng reviews để lưu đánh giá
    await db.execute('''
      CREATE TABLE reviews (
        ma_danh_gia TEXT PRIMARY KEY,
        ma_khach_hang TEXT,
        ma_mon TEXT,
        danh_gia INTEGER NOT NULL,
        nhan_xet TEXT,
        ngay_danh_gia TEXT NOT NULL,
        FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang(ma_khach_hang),
        FOREIGN KEY (ma_mon) REFERENCES mon_an(ma_mon)
      )
    ''');

    // Bảng promotions để lưu thông báo khuyến mãi
    await db.execute('''
      CREATE TABLE promotions (
        ma_khuyen_mai TEXT PRIMARY KEY,
        tieu_de TEXT NOT NULL,
        noi_dung TEXT,
        ngay_bat_dau TEXT NOT NULL,
        ngay_ket_thuc TEXT NOT NULL
      )
    ''');

    await db.execute('''
  CREATE TABLE cart (
    ma_nguoi_dung TEXT,
    ma_mon TEXT,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (ma_nguoi_dung, ma_mon),
    FOREIGN KEY (ma_nguoi_dung) REFERENCES users(ma_nguoi_dung),
    FOREIGN KEY (ma_mon) REFERENCES mon_an(ma_mon)
  )
''');

    await db.execute('''
      CREATE TABLE inventory (
        ma_nguyen_lieu TEXT PRIMARY KEY,
        ten_nguyen_lieu TEXT NOT NULL,
        so_luong_ton INTEGER NOT NULL,
        don_vi TEXT,
        nguong_canh_bao INTEGER,
        ghi_chu TEXT
      )
    ''');
    // Chèn dữ liệu ban đầu sau khi tạo bảng
    await insertInitialData(db);
  }

  // --- CÁC PHƯƠNG THỨC CRUD CHO nguoi_dung ---

  // Hàm insertUser: Chèn hoặc cập nhật người dùng (đã sửa để không loại bỏ mật khẩu)
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'nguoi_dung',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // KhachHang methods
  Future<Map<String, dynamic>?> getKhachHangByMa(String maKhachHang) async {
    final db = await database;
    final result = await db.query(
      'khach_hang',
      where: 'ma_khach_hang = ?',
      whereArgs: [maKhachHang],
    );
    return result.isNotEmpty ? result.first : null;
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

  // NhanVien methods
  Future<List<NhanVien>> getAllNhanVien() async {
    final db = await database;
    final result = await db.query('nhan_vien');
    return result.map((map) => NhanVien.fromMap(map)).toList();
  }

  Future<Map<String, dynamic>?> getNhanVienByMa(String maNhanVien) async {
    final db = await database;
    final result = await db.query(
      'nhan_vien',
      where: 'ma_nhan_vien = ?',
      whereArgs: [maNhanVien],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> insertNhanVien(Map<String, dynamic> nhanVien) async {
    final db = await database;
    await db.insert(
      'nhan_vien',
      nhanVien,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<void> deleteNhanVien(String maNhanVien) async {
    final db = await database;
    await db.delete(
      'nhan_vien',
      where: 'ma_nhan_vien = ?',
      whereArgs: [maNhanVien],
    );
  }

  // MonAn methods
  Future<List<MonAn>> getAllMonAn2() async {
    final db = await database;
    final result = await db.query('mon_an');
    return result.map((map) => MonAn.fromMap(map)).toList();
  }

  // Promotion methods
  Future<List<Map<String, dynamic>>> getAllPromotions() async {
    final db = await database;
    return await db.query('promotions');
  }

  Future<void> insertPromotion(Map<String, dynamic> promotion) async {
    final db = await database;
    await db.insert(
      'promotions',
      promotion,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePromotion(Map<String, dynamic> promotion) async {
    final db = await database;
    await db.update(
      'promotions',
      promotion,
      where: 'ma_khuyen_mai = ?',
      whereArgs: [promotion['ma_khuyen_mai']],
    );
  }

  Future<void> deletePromotion(String maKhuyenMai) async {
    final db = await database;
    await db.delete(
      'promotions',
      where: 'ma_khuyen_mai = ?',
      whereArgs: [maKhuyenMai],
    );
  }

  Future<String> generatePromotionId() async {
    final db = await database;
    final result = await db.query(
      'promotions',
      orderBy: 'ma_khuyen_mai DESC',
      limit: 1,
    );
    if (result.isEmpty) return 'KM001';
    final lastId = result.first['ma_khuyen_mai'] as String;
    final number = int.parse(lastId.replaceFirst('KM', '')) + 1;
    return 'KM${number.toString().padLeft(3, '0')}';
  }

  // Review methods
  Future<List<Map<String, dynamic>>> getAllReviews() async {
    final db = await database;
    return await db.query('reviews');
  }

  // Inventory methods
  Future<List<Map<String, dynamic>>> getAllInventory() async {
    final db = await database;
    return await db.query('inventory');
  }

  Future<void> insertInventory(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(
      'inventory',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateInventory(Map<String, dynamic> item) async {
    final db = await database;
    await db.update(
      'inventory',
      item,
      where: 'ma_nguyen_lieu = ?',
      whereArgs: [item['ma_nguyen_lieu']],
    );
  }

  Future<void> deleteInventory(String maNguyenLieu) async {
    final db = await database;
    await db.delete(
      'inventory',
      where: 'ma_nguyen_lieu = ?',
      whereArgs: [maNguyenLieu],
    );
  }

  Future<String> generateInventoryId() async {
    final db = await database;
    final result = await db.query(
      'inventory',
      orderBy: 'ma_nguyen_lieu DESC',
      limit: 1,
    );
    if (result.isEmpty) return 'NL001';
    final lastId = result.first['ma_nguyen_lieu'] as String;
    final number = int.parse(lastId.replaceFirst('NL', '')) + 1;
    return 'NL${number.toString().padLeft(3, '0')}';
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

  Future<List<Map<String, dynamic>>> getAllnguoi_dung() async {
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

  Future<void> insertKhachHang(Map<String, dynamic> khachHang) async {
    final db = await database;
    await db.insert(
      'khach_hang',
      khachHang,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  // Dành cho đơn hàng
  // Hàm tạo mã đơn hàng duy nhất
  Future<String> generateOrderId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM orders');
    final count = result.first['count'] as int;
    return 'DH${(count + 1).toString().padLeft(4, '0')}'; // Ví dụ: DH0001
  }

  // Hàm tạo mã đánh giá duy nhất
  Future<String> generateReviewId() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM reviews');
    final count = result.first['count'] as int;
    return 'DG${(count + 1).toString().padLeft(4, '0')}'; // Ví dụ: DG0001
  }

  // Thêm đơn hàng
  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    await db.insert('orders', order);
  }

  // Thêm chi tiết đơn hàng
  Future<void> insertOrderDetail(Map<String, dynamic> detail) async {
    final db = await database;
    await db.insert('order_details', detail);
  }

  // Lấy danh sách đơn hàng theo khách hàng
  Future<List<Map<String, dynamic>>> getOrdersByCustomer(
    String maKhachHang,
  ) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'ma_khach_hang = ?',
      whereArgs: [maKhachHang],
    );
  }

  // Lấy chi tiết đơn hàng
  Future<List<Map<String, dynamic>>> getOrderDetails(String maDonHang) async {
    final db = await database;
    return await db.query(
      'order_details',
      where: 'ma_don_hang = ?',
      whereArgs: [maDonHang],
    );
  }

  // Lấy tất cả đơn hàng (cho nhân viên/quản lý)
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    return await db.query('orders');
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String maDonHang, String trangThai) async {
    final db = await database;
    await db.update(
      'orders',
      {'trang_thai': trangThai},
      where: 'ma_don_hang = ?',
      whereArgs: [maDonHang],
    );
  }

  // Thêm đánh giá
  Future<void> insertReview(Map<String, dynamic> review) async {
    final db = await database;
    await db.insert('reviews', review);
  }

  // Lấy đánh giá theo món ăn
  Future<List<Map<String, dynamic>>> getReviewsByMonAn(String maMon) async {
    final db = await database;
    return await db.query('reviews', where: 'ma_mon = ?', whereArgs: [maMon]);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE inventory (
          ma_nguyen_lieu TEXT PRIMARY KEY,
          ten_nguyen_lieu TEXT NOT NULL,
          so_luong_ton INTEGER NOT NULL,
          don_vi TEXT,
          nguong_canh_bao INTEGER,
          ghi_chu TEXT
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE cart (
          ma_gio_hang TEXT PRIMARY KEY,
          ma_khach_hang TEXT,
          ma_mon_an TEXT,
          so_luong INTEGER,
          FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang (ma_khach_hang),
          FOREIGN KEY (ma_mon_an) REFERENCES mon_an (ma_mon_an)
        )
      ''');
      await db.execute('ALTER TABLE mon_an ADD COLUMN mo_ta TEXT');
      await db.execute('ALTER TABLE promotions ADD COLUMN gia_tri_giam REAL');
      await db.execute('ALTER TABLE reviews ADD COLUMN ngay_danh_gia TEXT');
    }
  }

  // Phương thức cho MonAn
  Future<List<Map<String, dynamic>>> getAllMonAn() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('MonAn');
    return maps;
  }

  Future<int> insertMonAn(Map<String, dynamic> monAn) async {
    final db = await instance.database;
    return await db.insert(
      'MonAn',
      monAn,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateMonAn(Map<String, dynamic> monAn) async {
    final db = await instance.database;
    return await db.update(
      'MonAn',
      monAn,
      where: 'ma_mon_an = ?',
      whereArgs: [monAn['ma_mon_an']],
    );
  }

  // Thêm phương thức này vào class QLQuanAnDatabaseHelper
  Future<int> getNextMaMonAn() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT MAX(CAST(SUBSTR(ma_mon, 3) AS INTEGER)) as maxId FROM mon_an",
    );
    // Kiểm tra nếu không có bản ghi nào, maxId sẽ là null.
    // Nếu có, lấy giá trị và cộng 1.
    final int? maxId = maps.isNotEmpty ? maps[0]['maxId'] : null;
    return (maxId ?? 0) + 1;
  }

  Future<int> getNextMaNhanVien() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT MAX(CAST(SUBSTR(ma_nhan_vien, 3) AS INTEGER)) as maxId FROM nhan_vien",
    );
    final int? maxId = maps.isNotEmpty ? maps[0]['maxId'] : null;
    return (maxId ?? 0) + 1;
  }

  // Phương thức cho LoaiMonAn
  Future<List<Map<String, dynamic>>> getAllLoaiMonAn() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('LoaiMonAn');
    return maps;
  }
}
