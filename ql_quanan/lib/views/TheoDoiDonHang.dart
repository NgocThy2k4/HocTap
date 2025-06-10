// views/TheoDoiDonHang.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';
import '../models/MonAn.dart';

class TheoDoiDonHang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUser = authController.currentUser;
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

    if (currentUser == null || currentUser.maVaiTro != 'KH') {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Theo Dõi Đơn Hàng',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFFB2D9),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            'Chỉ khách hàng mới có thể theo dõi đơn hàng.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theo Dõi Đơn Hàng',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: QLQuanAnDatabaseHelper.instance.getOrdersByCustomer(
          currentUser.maLienQuan!,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'Bạn chưa có đơn hàng nào.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ExpansionTile(
                  title: Text(
                    'Đơn hàng #${order['ma_don_hang']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Trạng thái: ${order['trang_thai']}'),
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: QLQuanAnDatabaseHelper.instance.getOrderDetails(
                        order['ma_don_hang'],
                      ),
                      builder: (context, detailSnapshot) {
                        if (!detailSnapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final details = detailSnapshot.data!;
                        return Column(
                          children: [
                            ...details.map(
                              (detail) => FutureBuilder<Map<String, dynamic>>(
                                future: QLQuanAnDatabaseHelper.instance.database
                                    .then(
                                      (db) => db
                                          .query(
                                            'mon_an',
                                            where: 'ma_mon = ?',
                                            whereArgs: [detail['ma_mon']],
                                          )
                                          .then((value) => value.first),
                                    ),
                                builder: (context, monAnSnapshot) {
                                  if (!monAnSnapshot.hasData) {
                                    return ListTile(title: Text('Đang tải...'));
                                  }
                                  final monAn = MonAn.fromMap(
                                    monAnSnapshot.data!,
                                  );
                                  return ListTile(
                                    leading: Image.asset(
                                      'assets/HinhAnh/MonAn/${monAn.hinh}',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.error),
                                    ),
                                    title: Text(monAn.tenMon),
                                    subtitle: Text(
                                      'Số lượng: ${detail['so_luong']} - Giá: ${currencyFormat.format(detail['don_gia'] * detail['so_luong'])}',
                                    ),
                                  );
                                },
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Tổng tiền: ${currencyFormat.format(order['tong_tien'])}',
                              ),
                              subtitle: Text(
                                'Địa chỉ: ${order['dia_chi_giao_hang']}\nPhương thức: ${order['phuong_thuc_thanh_toan']}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
