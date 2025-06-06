// main.dart (CẬP NHẬT để cập nhật CartController khi AuthController thay đổi)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/CartController.dart';
import 'controllers/AuthController.dart';
import 'views/auth/DangNhap.dart';
import 'views/TrangChu.dart';
import 'database/DatabaseHelper.dart'; // Import để khởi tạo DB

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Đảm bảo database được khởi tạo trước khi chạy ứng dụng
  await QLQuanAnDatabaseHelper.instance.database;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Quán Ăn',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Color(0xFFFFB2D9),
        hintColor: Color(0xFFFF6790),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFFFB2D9), width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6790),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: Consumer<AuthController>(
        builder: (context, auth, child) {
          // Khi AuthController thay đổi người dùng, cập nhật CartController
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<CartController>(
              context,
              listen: false,
            ).updateCurrentUser(auth.currentUser);
          });

          if (auth.isAuthenticated) {
            return TrangChu();
          } else {
            return DangNhap();
          }
        },
      ),
    );
  }
}
