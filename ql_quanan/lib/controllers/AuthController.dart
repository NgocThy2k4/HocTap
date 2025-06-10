// controllers/AuthController.dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Thêm dòng này để xử lý DatabaseException
import '../models/User.dart';
import '../models/KhachHang.dart';
import '../models/NhanVien.dart';
import '../database/DatabaseHelper.dart';
// import 'package:crypto/crypto.dart'; // Bỏ import này nếu không dùng SHA256 nữa
import 'dart:convert'; // Vẫn cần cho một số encoding khác nếu có, nhưng không dùng cho hash mật khẩu

enum AuthStatus { initial, loading, loggedIn, loggedOut, registered, error }

class AuthController extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  User? _currentUser;

  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated =>
      _currentUser != null && _status == AuthStatus.loggedIn;

  AuthController() {
    _loadCurrentUser(); // Vẫn giữ hàm này để khởi tạo trạng thái
  }

  Future<void> _loadCurrentUser() async {
    // Logic để tải người dùng hiện tại từ bộ nhớ (nếu có, VD: SharedPreferences)
    // Hiện tại, bạn chỉ đặt lại trạng thái về loggedOut.
    // Nếu bạn có logic lưu trạng thái đăng nhập, hãy thêm vào đây.
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  // BỎ HOẶC COMMENT HÀM _hashPassword NẾU BẠN MUỐN BỎ HOÀN TOÀN
  // String _hashPassword(String password) {
  //   var bytes = utf8.encode(password); // data being hashed
  //   var digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Phương thức đăng nhập - CẬP NHẬT PHẦN NÀY ĐỂ LẤY HÌNH ẢNH
  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    print('--- Bắt đầu đăng nhập ---');
    print('Email nhập: $email');
    print('Mật khẩu nhập: $password');

    try {
      final userMap = await _dbHelper.getUserByEmail(email);

      if (userMap != null) {
        final user = User.fromMap(userMap);
        print(
          'Tìm thấy user trong DB: ${user.email}, Ma Nguoi Dung: ${user.maNguoiDung}, Mat Khau DB: ${user.matKhau}',
        );

        // So sánh trực tiếp mật khẩu plain text
        if (user.matKhau == password) {
          _currentUser = user;

          // Bắt đầu logic lấy hình ảnh từ bảng liên quan
          String? hinhAnhPath; // Khởi tạo là null

          if (_currentUser!.maLienQuan != null) {
            final db = await _dbHelper.database;
            if (_currentUser!.maVaiTro == 'QL' ||
                _currentUser!.maVaiTro == 'NV') {
              // Là quản lý hoặc nhân viên, lấy ảnh từ bảng nhan_vien
              List<Map<String, dynamic>> nvResults = await db.query(
                'nhan_vien',
                columns: ['hinh_anh'],
                where: 'ma_nhan_vien = ?',
                whereArgs: [_currentUser!.maLienQuan!],
              );
              if (nvResults.isNotEmpty && nvResults.first['hinh_anh'] != null) {
                // Giả định 'hinh_anh' trong DB chỉ lưu tên file (ví dụ: 'avatar_admin.jpg')
                // Nếu DB lưu đường dẫn đầy đủ ('assets/HinhAnh/NhanVien/avatar_admin.jpg'), thì bỏ tiền tố
                hinhAnhPath = 'assets/HinhAnh/NhanVien/${nvResults.first['hinh_anh']}';
              }
            } else if (_currentUser!.maVaiTro == 'KH') {
              // Là khách hàng, lấy ảnh từ bảng khach_hang
              List<Map<String, dynamic>> khResults = await db.query(
                'khach_hang',
                columns: ['hinh_anh'],
                where: 'ma_khach_hang = ?',
                whereArgs: [_currentUser!.maLienQuan!],
              );
              if (khResults.isNotEmpty && khResults.first['hinh_anh'] != null) {
                // Giả định 'hinh_anh' trong DB chỉ lưu tên file (ví dụ: 'avatar_khach.jpg')
                // Nếu DB lưu đường dẫn đầy đủ ('assets/HinhAnh/KhachHang/avatar_khach.jpg'), thì bỏ tiền tố
                hinhAnhPath = 'assets/HinhAnh/KhachHang/${khResults.first['hinh_anh']}';
              }
            }
          }

          // --- BỔ SUNG LOGIC GÁN ẢNH MẶC ĐỊNH ---
          // Nếu hinhAnhPath vẫn là null (không tìm thấy ảnh riêng hoặc maLienQuan null),
          // gán ảnh mặc định dựa trên vai trò hoặc ảnh mặc định chung
          if (hinhAnhPath == null) {
            if (_currentUser!.maVaiTro == 'QL') {
              hinhAnhPath = 'assets/HinhAnh/NhanVien/default_admin.jpg';
            } else if (_currentUser!.maVaiTro == 'NV') {
              hinhAnhPath = 'assets/HinhAnh/NhanVien/default_nv.jpg';
            } else if (_currentUser!.maVaiTro == 'KH') {
              hinhAnhPath = 'assets/HinhAnh/KhachHang/default_kh.jpg';
            } else {
              // Trường hợp không xác định vai trò hoặc không có mã liên quan
              hinhAnhPath = 'assets/HinhAnh/KhachHang/default_user.jpg';
            }
          }
          // ------------------------------------

          // Gán đường dẫn hình ảnh (có thể là riêng hoặc mặc định) vào đối tượng User hiện tại
          _currentUser!.hinhAnh = hinhAnhPath;

          _status = AuthStatus.loggedIn;
          print('Đăng nhập thành công: ${user.email}');
          print('Đường dẫn hình ảnh: ${_currentUser!.hinhAnh ?? "Không có"}');
        } else {
          _errorMessage = 'Email hoặc mật khẩu không đúng.';
          _status = AuthStatus.error;
          print(
            'Lỗi: Mật khẩu không khớp. Mật khẩu DB: ${user.matKhau}, Mật khẩu nhập: $password',
          );
        }
      } else {
        _errorMessage = 'Email hoặc mật khẩu không đúng.';
        _status = AuthStatus.error;
        print('Lỗi: Không tìm thấy email: $email trong DB.');
      }
    } on DatabaseException catch (e) {
      _errorMessage = 'Lỗi cơ sở dữ liệu khi đăng nhập: ${e.toString()}';
      _status = AuthStatus.error;
      print('LỖI DB KHI ĐĂNG NHẬP: ${e.toString()}');
    } catch (e) {
      _errorMessage =
      'Đã xảy ra lỗi không xác định khi đăng nhập: ${e.toString()}';
      _status = AuthStatus.error;
      print('LỖI ĐĂNG NHẬP TỔNG QUÁT: ${e.toString()}');
    } finally {
      notifyListeners();
      print('--- Kết thúc đăng nhập ---');
    }
  }

  // Phương thức đăng ký - Giữ nguyên như trước, chỉ đảm bảo hinh_anh mặc định đúng
  Future<bool> register({
    required String tenDangNhap,
    required String email,
    required String matKhau,
    required String maVaiTro,
  }) async {
    _status = AuthStatus.loading; // Bắt đầu trạng thái loading
    _errorMessage = null;
    notifyListeners();

    print('--- Bắt đầu đăng ký ---');
    print('Tên đăng nhập: $tenDangNhap, Email: $email, Vai trò: $maVaiTro');

    try {
      // 1. Kiểm tra email đã tồn tại
      final existingUserByEmail = await _dbHelper.getUserByEmail(email);
      if (existingUserByEmail != null) {
        _errorMessage = 'Email đã tồn tại.';
        _status = AuthStatus.error;
        notifyListeners();
        print('Lỗi: Email đã tồn tại.');
        return false;
      }

      // 2. Kiểm tra tên đăng nhập đã tồn tại
      final existingUserByUsername = await _dbHelper.getUserByUsername(
        tenDangNhap,
      );
      if (existingUserByUsername != null) {
        _errorMessage = 'Tên đăng nhập đã tồn tại.';
        _status = AuthStatus.error;
        notifyListeners();
        print('Lỗi: Tên đăng nhập đã tồn tại.');
        return false;
      }

      String maLienQuan = '';
      String prefix = '';
      String defaultImagePath = ''; // Đường dẫn ảnh mặc định

      if (maVaiTro == 'KH') {
        prefix = 'KH';
        int nextIdNum = await _dbHelper.getNextMaNguoiDung(prefix);
        maLienQuan =
            '$prefix${nextIdNum.toString().padLeft(2, '0')}'; // VD: KH01, KH02
        defaultImagePath =
            'hinh1.jpg'; // Ảnh mặc định cho khách hàng (ví dụ: hinh1.jpg)

        print('Đăng ký khách hàng. maLienQuan: $maLienQuan');

        // CHÈN KHACHHANG VÀO DATABASE TRƯỚC
        KhachHang newKhachHang = KhachHang(
          maKhachHang: maLienQuan,
          tenKhachHang: tenDangNhap,
          diaChi: '',
          dienThoai: '',
          hinhAnh: defaultImagePath, // Gán ảnh mặc định
          ghiChu: '',
        );
        print('Đang chèn KhachHang: ${newKhachHang.toMap()}');
        await _dbHelper.insertKhachHang(newKhachHang.toMap());
        print('Chèn KhachHang thành công.');
      } else if (maVaiTro == 'NV' || maVaiTro == 'QL') {
        // Quản lý cũng là một loại nhân viên
        prefix = 'NV';
        int nextIdNum = await _dbHelper.getNextMaNguoiDung(prefix);
        maLienQuan =
            '$prefix${nextIdNum.toString().padLeft(2, '0')}'; // VD: NV01, NV02
        defaultImagePath =
            'nv_default.jpg'; // Ảnh mặc định cho nhân viên/quản lý (ví dụ: nv_default.jpg)

        print('Đăng ký nhân viên/quản lý. maLienQuan: $maLienQuan');

        // CHÈN NHANVIEN VÀO DATABASE TRƯỚC
        NhanVien newNhanVien = NhanVien(
          maNhanVien: maLienQuan,
          tenNhanVien: tenDangNhap,
          chucVu:
              maVaiTro == 'QL'
                  ? 'Quản Lý'
                  : 'Nhân Viên Mới', // Tùy chỉnh chức vụ
          diaChi: '',
          dienThoai: '',
          hinhAnh: defaultImagePath, // Gán ảnh mặc định
          ghiChu: '',
        );
        print('Đang chèn NhanVien: ${newNhanVien.toMap()}');
        await _dbHelper.insertNhanVien(newNhanVien.toMap());
        print('Chèn NhanVien thành công.');
      } else {
        _errorMessage = 'Vai trò không hợp lệ hoặc không được phép đăng ký.';
        _status = AuthStatus.error;
        notifyListeners();
        print('Lỗi: Vai trò không hợp lệ.');
        return false;
      }

      // Tạo User và chèn vào database, sử dụng mật khẩu PLAIN TEXT
      User newUser = User(
        maNguoiDung:
            maLienQuan, // ma_nguoi_dung và ma_lien_quan giống nhau khi đăng ký
        tenDangNhap: tenDangNhap,
        matKhau: matKhau, // LƯU MẬT KHẨU PLAIN TEXT
        email: email,
        maVaiTro: maVaiTro,
        maLienQuan: maLienQuan,
        hinhAnh:
            maVaiTro == 'KH'
                ? 'assets/HinhAnh/KhachHang/$defaultImagePath'
                : 'assets/HinhAnh/NhanVien/$defaultImagePath', // Gán đường dẫn đầy đủ
      );
      print('Đang chèn User: ${newUser.toMap()}');
      await _dbHelper.insertUser(newUser.toMap());
      print('Chèn User thành công.');

      _status = AuthStatus.registered; // Cập nhật trạng thái thành công
      _currentUser = newUser; // Cập nhật người dùng hiện tại
      _errorMessage = null;
      notifyListeners();
      print('--- Đăng ký hoàn tất thành công ---');
      return true;
    } on DatabaseException catch (e) {
      _errorMessage = 'Lỗi cơ sở dữ liệu: ${e.toString()}';
      _status = AuthStatus.error;
      print('LỖI DB KHI ĐĂNG KÝ: ${e.toString()}');
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định khi đăng ký: $e';
      _status = AuthStatus.error;
      notifyListeners();
      print('LỖI ĐĂNG KÝ TỔNG QUÁT: $e'); // In ra lỗi chi tiết
      return false;
    }
  }

  // Phương thức quên mật khẩu - Giữ nguyên như trước
  Future<bool> forgotPassword(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final userMap = await _dbHelper.getUserByEmail(email);

      if (userMap != null) {
        print(
          'Đã tìm thấy email: $email. (Trong thực tế sẽ gửi email đặt lại).',
        );
        _status = AuthStatus.loggedOut;
        _errorMessage =
            'Hướng dẫn đặt lại mật khẩu đã được gửi đến email của bạn (nếu email tồn tại).';
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email không tồn tại trong hệ thống.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } on DatabaseException catch (e) {
      _errorMessage =
          'Lỗi cơ sở dữ liệu khi yêu cầu đặt lại mật khẩu: ${e.toString()}';
      _status = AuthStatus.error;
      print('LỖI DB KHI YÊU CẦU QUÊN MẬT KHẨU: ${e.toString()}');
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage =
          'Đã xảy ra lỗi không xác định khi yêu cầu đặt lại mật khẩu: ${e.toString()}';
      _status = AuthStatus.error;
      print('LỖI QUÊN MẬT KHẨU TỔNG QUÁT: ${e.toString()}');
      notifyListeners();
      return false;
    }
  }

  // Hàm reset mật khẩu trực tiếp (không khuyến khích cho ứng dụng thực tế)
  Future<bool> resetPasswordDirectly(String email, String newPassword) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final userMap = await _dbHelper.getUserByEmail(email);
      if (userMap != null) {
        Map<String, dynamic> updatedUserMap = Map.from(userMap);
        updatedUserMap['mat_khau'] = newPassword; // LƯU MẬT KHẨU PLAIN TEXT

        await _dbHelper.updateUser(updatedUserMap);

        _status = AuthStatus.loggedOut;
        _errorMessage =
            'Mật khẩu của bạn đã được đặt lại thành công. Vui lòng đăng nhập.';
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email không tồn tại.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } on DatabaseException catch (e) {
      _errorMessage = 'Lỗi cơ sở dữ liệu khi đặt lại mật khẩu: ${e.toString()}';
      _status = AuthStatus.error;
      print('LỖI DB KHI RESET MẬT KHẨU TRỰC TIẾP: ${e.toString()}');
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage =
          'Đã xảy ra lỗi không xác định khi đặt lại mật khẩu: ${e.toString()}';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.initial;
    }
    notifyListeners();
  }

  void updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
