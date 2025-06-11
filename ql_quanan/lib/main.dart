import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/AuthController.dart';
import 'controllers/CartController.dart'; // **Thêm import này**
import 'views/auth/DangNhap.dart';
import 'views/TrangChu.dart';
import 'views/ThongTinCaNhan.dart';
import 'views/admin/QuanLyNhanVienPage.dart';
import 'views/admin/QuanLyKhachHangPage.dart';
import 'views/admin/QuanLyMonAnPage.dart';
import 'views/admin/QuanLyDoanhThuPage.dart';
import 'views/admin/QuanLyKhuyenMaiPage.dart';
import 'views/admin/QuanLyPhanHoiPage.dart';
import 'views/admin/QuanLyHangTonKhoPage.dart';
import 'views/TrangLienHe.dart';

void main() {
  runApp(QuaAnQuanApp());
}

class QuaAnQuanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sử dụng MultiProvider để cung cấp nhiều controller
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(
          create: (_) => CartController(),
        ), // **Cung cấp CartController**
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Bỏ nhãn debug
        title: 'Quản Lý Quán Ăn',
        theme: ThemeData(
          primaryColor: Color(0xFFFFB2D9),
          scaffoldBackgroundColor: Color(0xFFFCE4EC),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE91E63), // Màu nền của button
              foregroundColor:
                  Colors
                      .white, // SỬA LỖI: Đổi `onPrimary` thành `foregroundColor` (màu chữ/icon)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          textTheme: TextTheme(
            // SỬA LỖI: Đổi `bodyText1` thành `bodyLarge`
            bodyLarge: TextStyle(color: Colors.black87),
            // SỬA LỖI: Đổi `headline1` thành `displayLarge`
            displayLarge: TextStyle(
              color: Color(0xFFE91E63),
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: AppBarTheme(
            // Thêm theme cho AppBar để đồng bộ
            backgroundColor: Color(0xFFFFB2D9),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIconColor: Color(0xFFE91E63),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => DangNhap(),
          '/home': (context) => TrangChu(),
          '/thongTinCaNhan': (context) => ThongTinCaNhan(),
          '/quanLyNhanVien': (context) => QuanLyNhanVienPage(),
          '/quanLyKhachHang': (context) => QuanLyKhachHangPage(),
          '/quanLyMonAn': (context) => QuanLyMonAnPage(),
          '/quanLyDoanhThu': (context) => QuanLyDoanhThuPage(),
          '/quanLyKhuyenMai': (context) => QuanLyKhuyenMaiPage(),
          '/quanLyPhanHoi': (context) => QuanLyPhanHoiPage(),
          '/quanLyHangTonKho': (context) => QuanLyHangTonKhoPage(),
          '/lienHe': (context) => TrangLienHe(),
        },
      ),
    );
  }
}
