// controllers/AuthController.dart (CẬP NHẬT)

import 'package:flutter/material.dart';
import '../models/User.dart';
import '../models/KhachHang.dart'; // Import KhachHang model
import '../models/NhanVien.dart'; // Import NhanVien model
import '../database/DatabaseHelper.dart'; // Import DatabaseHelper

enum AuthStatus { initial, loading, loggedIn, loggedOut, registered, error }

class AuthController extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  User? _currentUser; // Chứa thông tin người dùng đã đăng nhập

  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated =>
      _currentUser != null && _status == AuthStatus.loggedIn;

  // Constructor để tải người dùng đã đăng nhập nếu có
  AuthController() {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    // Logic tải người dùng từ SharedPreferences hoặc persistent storage
    // Tạm thời, giả sử không có người dùng nào được lưu
    _status = AuthStatus.loggedOut; // Mặc định là đã đăng xuất khi khởi động
    notifyListeners();
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
        // Trong thực tế, bạn sẽ hash mật khẩu và so sánh mật khẩu đã hash
        if (user.email == email && userMap['mat_khau'] == password) {
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
  Future<void> register({
    required String tenDangNhap,
    required String email,
    required String password,
    required String maVaiTro, // 'KH' hoặc 'NV'
    String? maNhanVienTuNhap, // Chỉ dùng nếu đăng ký là nhân viên
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Kiểm tra email đã tồn tại trong bảng nguoi_dung
      final existingUser = await _dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        _errorMessage =
            'Email này đã được đăng ký. Vui lòng sử dụng email khác.';
        _status = AuthStatus.error;
        notifyListeners();
        return;
      }

      String newMaNguoiDung;
      String? maLienQuan; // ma_khach_hang hoặc ma_nhan_vien

      if (maVaiTro == 'KH') {
        // Đăng ký khách hàng
        int nextKhNumber = await _dbHelper.getNextMaNguoiDung('KH');
        newMaNguoiDung =
            'KH${nextKhNumber.toString().padLeft(2, '0')}'; // VD: KH01, KH02...
        maLienQuan = newMaNguoiDung; // ma_khach_hang trùng với ma_nguoi_dung

        // Thêm vào bảng khach_hang
        final khachHang = KhachHang(
          maKhachHang: newMaNguoiDung,
          tenKhachHang: tenDangNhap,
          hinhAnh: 'hinh1.jpg', // Ảnh mặc định
          diaChi: '', // Có thể cho phép nhập sau
          dienThoai: '', // Có thể cho phép nhập sau
          ghiChu: '',
        );
        await _dbHelper.insertKhachHang(khachHang.toMap());
      } else if (maVaiTro == 'NV') {
        // Đăng ký nhân viên
        if (maNhanVienTuNhap == null || maNhanVienTuNhap.isEmpty) {
          _errorMessage = 'Vui lòng nhập mã nhân viên.';
          _status = AuthStatus.error;
          notifyListeners();
          return;
        }

        // Kiểm tra mã nhân viên đã có trong bảng nhan_vien chưa
        final nhanVienData = await _dbHelper.getNhanVienByMa(maNhanVienTuNhap);
        if (nhanVienData == null) {
          _errorMessage = 'Mã nhân viên này không tồn tại trong hệ thống.';
          _status = AuthStatus.error;
          notifyListeners();
          return;
        }

        // Kiểm tra mã nhân viên này đã được đăng ký tài khoản người dùng chưa
        final existingUserByMaNV = await _dbHelper.getUserByMaNguoiDung(
          maNhanVienTuNhap,
        );
        if (existingUserByMaNV != null) {
          _errorMessage = 'Mã nhân viên này đã được đăng ký tài khoản.';
          _status = AuthStatus.error;
          notifyListeners();
          return;
        }

        newMaNguoiDung = maNhanVienTuNhap; // Ma_nguoi_dung sẽ là ma_nhan_vien
        maLienQuan = newMaNguoiDung; // ma_nhan_vien trùng với ma_nguoi_dung

        // Cập nhật thông tin nhân viên nếu cần (ví dụ: gán email)
        // Hiện tại không cần cập nhật thêm, vì thông tin chính đã có trong bảng nhan_vien
        // và chỉ cần liên kết người dùng với mã nhân viên đó.
        // Bạn có thể thêm logic cập nhật email, etc. nếu cần.
      } else {
        _errorMessage = 'Loại vai trò không hợp lệ.';
        _status = AuthStatus.error;
        notifyListeners();
        return;
      }

      // Thêm người dùng mới vào bảng nguoi_dung
      final newUser = User(
        maNguoiDung: newMaNguoiDung,
        tenDangNhap: tenDangNhap,
        email: email,
        maVaiTro: maVaiTro,
        maLienQuan: maLienQuan,
      );
      await _dbHelper.insertUser(newUser.toMap());

      _currentUser = newUser; // Đặt người dùng hiện tại là người vừa đăng ký
      _status = AuthStatus.registered;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng ký: ${e.toString()}';
      _status = AuthStatus.error;
    } finally {
      notifyListeners();
    }
  }

  // Đăng xuất
  void logout() {
    _currentUser = null;
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  // Đặt lại trạng thái lỗi
  void resetError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.initial;
    }
    notifyListeners();
  }

  // Thêm vào AuthController:
  void updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
