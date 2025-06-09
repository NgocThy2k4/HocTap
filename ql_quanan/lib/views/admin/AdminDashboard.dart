import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/AuthController.dart';
import '../auth/DangNhap.dart'; // Import DangNhap nếu cần
import 'QuanLyNhanVienPage.dart';
import 'QuanLyKhachHangPage.dart';
import 'QuanLyMonAnPage.dart';
// import các trang quản lý khác nếu có

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // Đảm bảo người dùng là Admin, nếu không thì redirect về DangNhap
    if (authController.currentUser == null ||
        authController.currentUser!.maVaiTro != 'QL') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DangNhap()),
          (Route<dynamic> route) => false,
        );
      });
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ), // Hoặc một màn hình loading/redirect
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bảng Điều Khiển Quản Lý',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(Icons.people, color: Colors.blueAccent),
                title: Text(
                  'Quản Lý Nhân Viên',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuanLyNhanVienPage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(Icons.group, color: Colors.green),
                title: Text(
                  'Quản Lý Khách Hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuanLyKhachHangPage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(Icons.fastfood, color: Colors.orange),
                title: Text(
                  'Quản Lý Món Ăn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuanLyMonAnPage()),
                  );
                },
              ),
            ),
            // Thêm các chức năng quản lý khác ở đây
          ],
        ),
      ),
    );
  }
}
