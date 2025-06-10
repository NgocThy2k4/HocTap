// views/TheoDoiPhanHoi.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';
import '../models/MonAn.dart';

class TheoDoiPhanHoi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUser = authController.currentUser;

    if (currentUser == null || !['NV', 'QL'].contains(currentUser.maVaiTro)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Theo Dõi Phản Hồi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFFB2D9),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            'Chỉ nhân viên hoặc quản lý mới có thể xem phản hồi.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theo Dõi Phản Hồi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: QLQuanAnDatabaseHelper.instance.getAllReviews(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final reviews = snapshot.data!;
          if (reviews.isEmpty) {
            return Center(
              child: Text(
                'Hiện tại không có đánh giá nào.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: QLQuanAnDatabaseHelper.instance.database.then(
                    (db) => db
                        .query(
                          'mon_an',
                          where: 'ma_mon = ?',
                          whereArgs: [review['ma_mon']],
                        )
                        .then((value) => value.isNotEmpty ? value.first : {}),
                  ),
                  builder: (context, monAnSnapshot) {
                    final monAn =
                        monAnSnapshot.hasData && monAnSnapshot.data!.isNotEmpty
                            ? MonAn.fromMap(monAnSnapshot.data!)
                            : null;
                    return ListTile(
                      title: Text(
                        monAn != null ? monAn.tenMon : 'Dịch vụ chung',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < review['danh_gia']
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                                size: 20,
                              ),
                            ),
                          ),
                          Text(review['nhan_xet'] ?? 'Không có nhận xét'),
                          Text('Ngày: ${review['ngay_danh_gia']}'),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
