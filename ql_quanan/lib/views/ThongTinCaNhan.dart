// views/ThongTinCaNhan.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';
import '../models/User.dart';
import '../models/KhachHang.dart';
import '../models/NhanVien.dart';

class ThongTinCaNhan extends StatefulWidget {
  @override
  _ThongTinCaNhanState createState() => _ThongTinCaNhanState();
}

class _ThongTinCaNhanState extends State<ThongTinCaNhan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _chucVuController =
      TextEditingController(); // Chỉ cho nhân viên

  User? _currentUser;
  String? _currentRoleSpecificId; // ma_khach_hang hoặc ma_nhan_vien
  String? _currentProfileImage; // Đường dẫn ảnh hồ sơ

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    _currentUser =
        Provider.of<AuthController>(context, listen: false).currentUser;
    if (_currentUser != null) {
      _usernameController.text = _currentUser!.tenDangNhap;
      _emailController.text = _currentUser!.email;
      _currentRoleSpecificId = _currentUser!.maLienQuan;

      final dbHelper = QLQuanAnDatabaseHelper.instance;

      if (_currentUser!.maVaiTro == 'KH') {
        final khachHangMap = await dbHelper.getKhachHangByMa(
          _currentRoleSpecificId!,
        );
        if (khachHangMap != null) {
          final khachHang = KhachHang.fromMap(khachHangMap);
          _addressController.text = khachHang.diaChi ?? '';
          _phoneController.text = khachHang.dienThoai ?? '';
          _notesController.text = khachHang.ghiChu ?? '';
          _currentProfileImage = khachHang.hinhAnh;
        }
      } else if (_currentUser!.maVaiTro == 'NV' ||
          _currentUser!.maVaiTro == 'QL') {
        final nhanVienMap = await dbHelper.getNhanVienByMa(
          _currentRoleSpecificId!,
        );
        if (nhanVienMap != null) {
          final nhanVien = NhanVien.fromMap(nhanVienMap);
          _addressController.text = nhanVien.diaChi ?? '';
          _phoneController.text = nhanVien.dienThoai ?? '';
          _notesController.text = nhanVien.ghiChu ?? '';
          _chucVuController.text = nhanVien.chucVu ?? '';
          _currentProfileImage = nhanVien.hinhAnh;
        }
      }
      setState(() {});
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_currentUser == null || _currentRoleSpecificId == null) return;

      final dbHelper = QLQuanAnDatabaseHelper.instance;
      bool updateSuccess = false;

      // Cập nhật bảng nguoi_dung
      await dbHelper.insertUser({
        'ma_nguoi_dung': _currentUser!.maNguoiDung,
        'ten_dang_nhap': _usernameController.text,
        'mat_khau': _currentUser!.toMap()['mat_khau'], // Giữ nguyên mật khẩu
        'email': _emailController.text,
        'ma_vai_tro': _currentUser!.maVaiTro,
        'ma_lien_quan': _currentRoleSpecificId,
      });

      if (_currentUser!.maVaiTro == 'KH') {
        final khachHang = KhachHang(
          maKhachHang: _currentRoleSpecificId!,
          tenKhachHang: _usernameController.text,
          diaChi: _addressController.text,
          dienThoai: _phoneController.text,
          hinhAnh: _currentProfileImage, // Giữ nguyên ảnh
          ghiChu: _notesController.text,
        );
        await dbHelper.updateKhachHang(
          khachHang.toMap(),
        ); // Cần thêm updateKhachHang vào DatabaseHelper
        updateSuccess = true;
      } else if (_currentUser!.maVaiTro == 'NV' ||
          _currentUser!.maVaiTro == 'QL') {
        final nhanVien = NhanVien(
          maNhanVien: _currentRoleSpecificId!,
          tenNhanVien: _usernameController.text,
          chucVu: _chucVuController.text,
          diaChi: _addressController.text,
          dienThoai: _phoneController.text,
          hinhAnh: _currentProfileImage, // Giữ nguyên ảnh
          ghiChu: _notesController.text,
        );
        await dbHelper.updateNhanVien(
          nhanVien.toMap(),
        ); // Cần thêm updateNhanVien vào DatabaseHelper
        updateSuccess = true;
      }

      // views/ThongTinCaNhan.dart
      // ...
      if (updateSuccess) {
        // Cập nhật lại currentUser trong AuthController
        Provider.of<AuthController>(context, listen: false).updateCurrentUser(
          User(
            maNguoiDung: _currentUser!.maNguoiDung,
            tenDangNhap: _usernameController.text,
            matKhau: _currentUser!.matKhau, // <--- THÊM DÒNG NÀY
            email: _emailController.text,
            maVaiTro: _currentUser!.maVaiTro,
            maLienQuan: _currentRoleSpecificId,
          ),
        );
        // ...

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cập nhật thông tin thành công!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Không thể cập nhật thông tin.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _chucVuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thông Tin Cá Nhân',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFFFB2D9),
        ),
        body: Center(child: Text('Bạn chưa đăng nhập.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Tin Cá Nhân',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _currentProfileImage != null
                          ? AssetImage(
                            'assets/HinhAnh/KhachHang/${_currentProfileImage}',
                          ) // Tùy chỉnh đường dẫn ảnh NV
                          : null,
                  child:
                      _currentProfileImage == null
                          ? Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.person, color: Color(0xFFFFB2D9)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên đăng nhập không được để trống.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFFFFB2D9)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email không được để trống.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email không hợp lệ.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_currentUser!.maVaiTro == 'NV' ||
                  _currentUser!.maVaiTro == 'QL')
                TextFormField(
                  controller: _chucVuController,
                  readOnly:
                      true, // Chức vụ thường không được chỉnh sửa bởi người dùng
                  decoration: InputDecoration(
                    labelText: 'Chức vụ',
                    prefixIcon: Icon(Icons.work, color: Color(0xFFFFB2D9)),
                  ),
                ),
              if (_currentUser!.maVaiTro == 'NV' ||
                  _currentUser!.maVaiTro == 'QL')
                SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  prefixIcon: Icon(Icons.location_on, color: Color(0xFFFFB2D9)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone, color: Color(0xFFFFB2D9)),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: Icon(Icons.note, color: Color(0xFFFFB2D9)),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _updateUserProfile,
                  icon: Icon(Icons.save),
                  label: Text('Lưu Thay Đổi'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
