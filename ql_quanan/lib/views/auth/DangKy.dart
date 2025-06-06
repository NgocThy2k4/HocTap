// views/auth/DangKy.dart (CẬP NHẬT)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/AuthController.dart';
import 'DangNhap.dart'; // Điều hướng về trang đăng nhập sau khi đăng ký

enum UserType { customer, employee }

class DangKy extends StatefulWidget {
  @override
  _DangKyState createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(); // Thêm tên đăng nhập
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _employeeIdController =
      TextEditingController(); // Mã nhân viên

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserType _selectedUserType = UserType.customer; // Mặc định là khách hàng

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên đăng nhập.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải có ít nhất một chữ cái viết hoa.';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Mật khẩu phải có ít nhất một chữ cái viết thường.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải có ít nhất một chữ số.';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Mật khẩu phải có ít nhất một ký tự đặc biệt.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu.';
    }
    if (value != _passwordController.text) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    return null;
  }

  String? _validateEmployeeId(String? value) {
    if (_selectedUserType == UserType.employee) {
      if (value == null || value.isEmpty) {
        return 'Vui lòng nhập mã nhân viên.';
      }
      // Bạn có thể thêm regex hoặc các kiểm tra định dạng khác cho mã nhân viên
      // if (!RegExp(r'^NV\d{2}$').hasMatch(value)) {
      //   return 'Mã nhân viên không hợp lệ (ví dụ: NV01).';
      // }
    }
    return null;
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      String maVaiTro = _selectedUserType == UserType.customer ? 'KH' : 'NV';
      String? maNhanVien =
          _selectedUserType == UserType.employee
              ? _employeeIdController.text
              : null;

      await authController.register(
        tenDangNhap: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        maVaiTro: maVaiTro,
        maNhanVienTuNhap: maNhanVien,
      );

      if (authController.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đăng ký thành công! Vui lòng đăng nhập.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DangNhap()),
        );
      } else if (authController.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authController.errorMessage ?? 'Đăng ký thất bại.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        authController.resetError();
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng Ký',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/HinhAnh/NenDangKy.jpg', // Ảnh nền
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: Container(color: Colors.black.withOpacity(0.5)),
          // ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ví dụ code mới dùng CircleAvatar
                  CircleAvatar(
                    radius: 75, // Bán kính 75 sẽ tạo ra đường kính 150 (tương đương width/height cũ)
                    backgroundImage: AssetImage('assets/HinhAnh/Logo.jpg'),
                  ),
                  // Image.asset(
                  //   'assets/HinhAnh/Logo.jpg', // Thay bằng logo của bạn
                  //   height: 120,
                  // ),
                  SizedBox(height: 20),
                  Text(
                    'Tạo Tài Khoản Mới',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Tên đăng nhập',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xFFFFB2D9),
                            ),
                          ),
                          validator: _validateUsername,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xFFFFB2D9),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xFFFFB2D9),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFFFF6790),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Xác nhận mật khẩu',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            prefixIcon: Icon(
                              Icons.lock_reset,
                              color: Color(0xFFFFB2D9),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFFFF6790),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: _validateConfirmPassword,
                        ),
                        SizedBox(height: 20),
                        // Radio Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<UserType>(
                              value: UserType.customer,
                              groupValue: _selectedUserType,
                              onChanged: (UserType? value) {
                                setState(() {
                                  _selectedUserType = value!;
                                });
                              },
                              activeColor: Color(0xFFFF6790),
                            ),
                            Text(
                              'Đăng ký Khách hàng',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 20),
                            Radio<UserType>(
                              value: UserType.employee,
                              groupValue: _selectedUserType,
                              onChanged: (UserType? value) {
                                setState(() {
                                  _selectedUserType = value!;
                                });
                              },
                              activeColor: Color(0xFFFF6790),
                            ),
                            Text(
                              'Đăng ký Nhân viên',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Mã Nhân Viên chỉ hiển thị khi chọn Nhân viên
                        if (_selectedUserType == UserType.employee)
                          TextFormField(
                            controller: _employeeIdController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Mã nhân viên',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              prefixIcon: Icon(
                                Icons.badge,
                                color: Color(0xFFFFB2D9),
                              ),
                              hintText: 'Ví dụ: NV01',
                            ),
                            validator: _validateEmployeeId,
                          ),
                        SizedBox(height: 30),
                        Consumer<AuthController>(
                          builder: (context, auth, child) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    auth.status == AuthStatus.loading
                                        ? null
                                        : _handleRegister,
                                child:
                                    auth.status == AuthStatus.loading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text('Đăng Ký'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Quay lại trang đăng nhập
                    },
                    child: Text(
                      'Đã có tài khoản? Đăng nhập',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
