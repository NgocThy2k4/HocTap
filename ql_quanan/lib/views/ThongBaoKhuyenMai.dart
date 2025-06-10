// views/ThongBaoKhuyenMai.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';

class ThongBaoKhuyenMai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUser = authController.currentUser;

    if (currentUser == null || currentUser.maVaiTro != 'KH') {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thông Báo Khuyến Mãi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFFB2D9),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            'Chỉ khách hàng mới có thể xem khuyến mãi.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Báo Khuyến Mãi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: QLQuanAnDatabaseHelper.instance.getAllPromotions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final promotions = snapshot.data!;
          if (promotions.isEmpty) {
            return Center(
              child: Text(
                'Hiện tại không có khuyến mãi nào.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promo = promotions[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(
                    promo['tieu_de'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${promo['noi_dung']}\nTừ: ${promo['ngay_bat_dau']}\nĐến: ${promo['ngay_ket_thuc']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
