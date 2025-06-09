// controllers/AuthController.dart

import 'package:flutter/material.dart';
// import 'package:crypto/crypto.dart'; // Bỏ import này nếu không dùng SHA256 nữa
import 'dart:convert'; // Vẫn cần cho một số encoding khác nếu có, nhưng không dùng cho hash mật khẩu
import '../models/User.dart';
import '../models/KhachHang.dart';
import '../models/NhanVien.dart';
import '../database/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart'; // Thêm dòng này để xử lý DatabaseException

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
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  // BỎ HOẶC COMMENT HÀM _hashPassword NẾU BẠN MUỐN BỎ HOÀN TOÀN
  // String _hashPassword(String password) {
  //   var bytes = utf8.encode(password); // data being hashed
  //   var digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Phương thức đăng nhập - CẬP NHẬT PHẦN NÀY
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
        // BỎ DÒNG HASH NÀY
        // final hashedPassword = _hashPassword(password); // Hash mật khẩu nhập vào để so sánh

        // SO SÁNH TRỰC TIẾP VỚI MẬT KHẨU PLAIN TEXT TỪ DB
        if (user.matKhau == password) {
          // So sánh trực tiếp 'password' với 'user.matKhau'
          _currentUser = user;
          _status = AuthStatus.loggedIn;
          print('Đăng nhập thành công: ${user.email}');
        } else {
          _errorMessage = 'Email hoặc mật khẩu không đúng.';
          _status = AuthStatus.error;
          // Cập nhật log để phản ánh việc không hash
          print(
            'Lỗi: Mật khẩu không khớp. Mật khẩu DB: ${user.matKhau}, Mật khẩu nhập: $password',
          );
        }
      } else {
        _errorMessage = 'Email hoặc mật khẩu không đúng.';
        _status = AuthStatus.error;
        print('Lỗi: Không tìm thấy email: ${email} trong DB.');
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

  // Phương thức đăng ký - Giữ nguyên như trước (đã bao gồm log)
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

      // BỎ DÒNG HASH MẬT KHẨU NÀY
      // final hashedPassword = _hashPassword(matKhau);
      // print('Mật khẩu đã hash: $hashedPassword');

      // Tạo User và chèn vào database, sử dụng mật khẩu PLAIN TEXT
      User newUser = User(
        maNguoiDung:
            maLienQuan, // ma_nguoi_dung và ma_lien_quan giống nhau khi đăng ký
        tenDangNhap: tenDangNhap,
        matKhau: matKhau, // LƯU MẬT KHẨU PLAIN TEXT
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
        // BỎ DÒNG HASH MẬT KHẨU NÀY
        // final password = _hashPassword(newPassword);
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
