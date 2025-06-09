// controllers/AuthController.dart

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // Import để sử dụng SHA256
import 'dart:convert'; // Import để sử dụng utf8.encode
import '../models/User.dart';
import '../models/KhachHang.dart';
import '../models/NhanVien.dart';
import '../database/DatabaseHelper.dart';

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
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    // Tạm thời, giả sử không có người dùng nào được lưu
    // Nếu bạn có lưu user session bằng SharedPreferences, hãy load ở đây
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  // Hàm hash mật khẩu
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Phương thức đăng nhập
  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final userMap = await _dbHelper.getUserByEmail(email);

      if (userMap != null) {
        final user = User.fromMap(userMap);
        final hashedPassword = _hashPassword(
          password,
        ); // Hash mật khẩu nhập vào để so sánh

        if (user.email == email && user.matKhau == hashedPassword) {
          // So sánh với mật khẩu đã hash trong DB
          _currentUser = user;
          _status = AuthStatus.loggedIn;
        } else {
          _errorMessage = 'Email hoặc mật khẩu không đúng.';
          _status = AuthStatus.error;
        }
      } else {
        _errorMessage = 'Email hoặc mật khẩu không đúng.';
        _status = AuthStatus.error;
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng nhập: ${e.toString()}';
      _status = AuthStatus.error;
    } finally {
      notifyListeners();
    }
  }

  // Phương thức đăng ký
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

      // 2. Kiểm tra tên đăng nhập đã tồn tại (optional, nhưng tốt cho UX)
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

      if (maVaiTro == 'KH') {
        prefix = 'KH';
        int nextIdNum = await _dbHelper.getNextMaNguoiDung(prefix);
        maLienQuan =
            '$prefix${nextIdNum.toString().padLeft(2, '0')}'; // VD: KH01, KH02

        print('Đăng ký khách hàng. maLienQuan: $maLienQuan');

        // CHÈN KHACHHANG VÀO DATABASE TRƯỚC
        KhachHang newKhachHang = KhachHang(
          maKhachHang: maLienQuan,
          tenKhachHang: tenDangNhap,
          diaChi: '',
          dienThoai: '',
          hinhAnh:
              'default_customer.png', // Đảm bảo ảnh này tồn tại trong assets/HinhAnh
          ghiChu: '',
        );
        print('Đang chèn KhachHang: ${newKhachHang.toMap()}');
        await _dbHelper.insertKhachHang(newKhachHang.toMap());
        print('Chèn KhachHang thành công.');
      } else if (maVaiTro == 'NV') {
        prefix = 'NV';
        int nextIdNum = await _dbHelper.getNextMaNguoiDung(prefix);
        maLienQuan =
            '$prefix${nextIdNum.toString().padLeft(2, '0')}'; // VD: NV01, NV02

        print('Đăng ký nhân viên. maLienQuan: $maLienQuan');

        // CHÈN NHANVIEN VÀO DATABASE TRƯỚC
        NhanVien newNhanVien = NhanVien(
          maNhanVien: maLienQuan,
          tenNhanVien: tenDangNhap,
          chucVu:
              'Nhân viên mới', // Cần thiết lập giá trị mặc định hoặc cho phép nhập
          diaChi: '',
          dienThoai: '',
          hinhAnh:
              'default_employee.png', // Đảm bảo ảnh này tồn tại trong assets/HinhAnh
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

      // Hash mật khẩu trước khi lưu vào DB
      final hashedPassword = _hashPassword(matKhau);
      print('Mật khẩu đã hash: $hashedPassword');

      // Tạo User và chèn vào database
      User newUser = User(
        maNguoiDung:
            maLienQuan, // ma_nguoi_dung và ma_lien_quan giống nhau khi đăng ký
        tenDangNhap: tenDangNhap,
        matKhau: hashedPassword, // Sử dụng mật khẩu đã hash
        email: email,
        maVaiTro: maVaiTro,
        maLienQuan: maLienQuan,
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
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng ký: $e';
      _status = AuthStatus.error;
      notifyListeners();
      print('LỖI ĐĂNG KÝ NGOẠI LỆ: $e'); // In ra lỗi chi tiết
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
