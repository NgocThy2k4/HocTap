import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/AuthController.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Bỏ nhãn debug
        title: 'Quản Lý Quán Ăn',
        theme: ThemeData(
          primaryColor: Color(0xFFFFB2D9),
          scaffoldBackgroundColor: Color(0xFFFCE4EC),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black87),
            headline1: TextStyle(
              color: Color(0xFFE91E63),
              fontWeight: FontWeight.bold,
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
          '/login': (context) => LoginPage(),
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
