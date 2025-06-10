// views/auth/DangKy.dart

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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // _employeeIdController không cần thiết nếu logic tạo mã được xử lý trong AuthController

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

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      String maVaiTro = _selectedUserType == UserType.customer ? 'KH' : 'NV';

      // Không cần maNhanVienTuNhap ở đây, logic tạo mã được xử lý trong AuthController

      await authController.register(
        tenDangNhap: _usernameController.text,
        email: _emailController.text,
        matKhau: _passwordController.text, // Mật khẩu được truyền vào đây
        maVaiTro: maVaiTro,
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
    // _employeeIdController.dispose(); // Không cần dispose nếu không dùng
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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tạo Tài Khoản Mới',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6790),
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
                              'Khách hàng',
                              style: TextStyle(color: Color(0xFFFF6790)),
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
                              'Nhân viên',
                              style: TextStyle(color: Color(0xFFFF6790)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Mã Nhân Viên không cần thiết ở đây nữa
                        // if (_selectedUserType == UserType.employee)
                        //   TextFormField(
                        //     controller: _employeeIdController,
                        //     style: TextStyle(color: Colors.black),
                        //     decoration: InputDecoration(
                        //       labelText: 'Mã nhân viên',
                        //       labelStyle: TextStyle(color: Colors.grey[700]),
                        //       prefixIcon: Icon(
                        //         Icons.badge,
                        //         color: Color(0xFFFFB2D9),
                        //       ),
                        //       hintText: 'Ví dụ: NV01',
                        //     ),
                        //     validator: _validateEmployeeId, // Nếu vẫn muốn validate
                        //   ),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF6790),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child:
                                    auth.status == AuthStatus.loading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          'Đăng Ký',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
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
                      style: TextStyle(color: Color(0xFFFF6790)),
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
