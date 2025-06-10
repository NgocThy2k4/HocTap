// views/ThongTinCaNhan.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';
import '../models/User.dart';
import '../models/KhachHang.dart';
import '../models/NhanVien.dart';
import 'dart:io';

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
  final TextEditingController _chucVuController = TextEditingController();

  User? _currentUser;
  String? _currentRoleSpecificId;
  String? _currentProfileImage; // Lưu tên file ảnh (không bao gồm đường dẫn)
  File? _selectedImage; // Ảnh mới được chọn từ thư viện

  final ImagePicker _picker = ImagePicker();

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
      _currentProfileImage = _currentUser!.hinhAnh;

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _currentProfileImage = pickedFile.path.split('/').last; // Lưu tên file
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_currentUser == null || _currentRoleSpecificId == null) return;

      final dbHelper = QLQuanAnDatabaseHelper.instance;
      bool updateSuccess = false;

      // Cập nhật bảng nguoi_dung
      final userMap = {
        'ma_nguoi_dung': _currentUser!.maNguoiDung,
        'ten_dang_nhap': _usernameController.text,
        'mat_khau': _currentUser!.matKhau,
        'email': _emailController.text,
        'ma_vai_tro': _currentUser!.maVaiTro,
        'ma_lien_quan': _currentRoleSpecificId,
        'hinh_anh': _currentProfileImage, // Cập nhật tên file ảnh
      };
      await dbHelper.insertUser(userMap);

      if (_currentUser!.maVaiTro == 'KH') {
        final khachHang = KhachHang(
          maKhachHang: _currentRoleSpecificId!,
          tenKhachHang: _usernameController.text,
          diaChi: _addressController.text,
          dienThoai: _phoneController.text,
          hinhAnh: _currentProfileImage,
          ghiChu: _notesController.text,
        );
        await dbHelper.updateKhachHang(khachHang.toMap());
        updateSuccess = true;
      } else if (_currentUser!.maVaiTro == 'NV' ||
          _currentUser!.maVaiTro == 'QL') {
        // Kiểm tra chức vụ không phải "Quản Lý" nếu là nhân viên
        if (_currentUser!.maVaiTro == 'NV' &&
            _chucVuController.text.toLowerCase() == 'quản lý') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nhân viên không thể chọn chức vụ Quản Lý.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        final nhanVien = NhanVien(
          maNhanVien: _currentRoleSpecificId!,
          tenNhanVien: _usernameController.text,
          chucVu: _chucVuController.text,
          diaChi: _addressController.text,
          dienThoai: _phoneController.text,
          hinhAnh: _currentProfileImage,
          ghiChu: _notesController.text,
        );
        await dbHelper.updateNhanVien(nhanVien.toMap());
        updateSuccess = true;
      }

      if (updateSuccess) {
        Provider.of<AuthController>(context, listen: false).updateCurrentUser(
          User(
            maNguoiDung: _currentUser!.maNguoiDung,
            tenDangNhap: _usernameController.text,
            matKhau: _currentUser!.matKhau,
            email: _emailController.text,
            maVaiTro: _currentUser!.maVaiTro,
            maLienQuan: _currentRoleSpecificId,
            hinhAnh: _currentProfileImage,
          ),
        );
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
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : _currentProfileImage != null
                              ? AssetImage(
                                _currentUser!.maVaiTro == 'KH'
                                    ? 'assets/HinhAnh/KhachHang/$_currentProfileImage'
                                    : 'assets/HinhAnh/NhanVien/$_currentProfileImage',
                              )
                              : null,
                      child:
                          _currentProfileImage == null && _selectedImage == null
                              ? Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFFFB2D9),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.person, color: Color(0xFFFFB2D9)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Tên đăng nhập không được để trống.'
                            : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFFFFB2D9)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email không được để trống.';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return 'Email không hợp lệ.';
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_currentUser!.maVaiTro == 'NV')
                TextFormField(
                  controller: _chucVuController,
                  decoration: InputDecoration(
                    labelText: 'Chức vụ',
                    prefixIcon: Icon(Icons.work, color: Color(0xFFFFB2D9)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Chức vụ không được để trống.'
                              : null,
                ),
              if (_currentUser!.maVaiTro == 'QL')
                TextFormField(
                  controller: _chucVuController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Chức vụ',
                    prefixIcon: Icon(Icons.work, color: Color(0xFFFFB2D9)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  prefixIcon: Icon(Icons.location_on, color: Color(0xFFFFB2D9)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone, color: Color(0xFFFFB2D9)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: Icon(Icons.note, color: Color(0xFFFFB2D9)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _updateUserProfile,
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(
                    'Lưu Thay Đổi',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
