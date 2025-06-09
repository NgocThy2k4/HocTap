// views/auth/QuenMatKhau.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/AuthController.dart'; // Đảm bảo đường dẫn đúng

class QuenMatKhau extends StatefulWidget {
  @override
  _QuenMatKhauState createState() => _QuenMatKhauState();
}

class _QuenMatKhauState extends State<QuenMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  void _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );

      // Gọi hàm quên mật khẩu trong AuthController
      // Hiện tại chúng ta sẽ chỉ giả lập, trong thực tế sẽ có logic gửi email/OTP
      bool success = await authController.forgotPassword(_emailController.text);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hướng dẫn đặt lại mật khẩu đã được gửi đến email của bạn (nếu email tồn tại).',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.pop(context); // Quay lại trang đăng nhập
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authController.errorMessage ?? 'Có lỗi xảy ra khi xử lý yêu cầu.',
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên Mật Khẩu'),
        backgroundColor: Color(0xFFFF6790),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/HinhAnh/NenDangKy.jpg', // Ảnh nền tương tự trang đăng nhập
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
                    'Đặt Lại Mật Khẩu',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6790),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Vui lòng nhập địa chỉ email đã đăng ký của bạn để nhận hướng dẫn đặt lại mật khẩu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Màu chữ cho mô tả
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email của bạn',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        prefixIcon: Icon(Icons.email, color: Color(0xFFFFB2D9)),
                      ),
                      validator: _validateEmail,
                    ),
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
                                  : _handleForgotPassword,
                          child:
                              auth.status == AuthStatus.loading
                                  ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text('Gửi yêu cầu đặt lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6790), // Màu hồng
                            foregroundColor: Colors.white, // Màu chữ trắng
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    },
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
