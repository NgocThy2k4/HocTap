// views/DanhGiaNhanXet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';

class DanhGiaNhanXet extends StatefulWidget {
  final String? maMon; // Tùy chọn: nếu đánh giá cụ thể món ăn
  DanhGiaNhanXet({this.maMon});

  @override
  _DanhGiaNhanXetState createState() => _DanhGiaNhanXetState();
}

class _DanhGiaNhanXetState extends State<DanhGiaNhanXet> {
  final _formKey = GlobalKey<FormState>();
  final _nhanXetController = TextEditingController();
  int _danhGia = 5;

  @override
  void dispose() {
    _nhanXetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUser = authController.currentUser;

    if (currentUser == null || currentUser.maVaiTro != 'KH') {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Đánh Giá và Nhận Xét',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFFB2D9),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            'Chỉ khách hàng mới có thể gửi đánh giá.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đánh Giá và Nhận Xét',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đánh giá của bạn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _danhGia ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        _danhGia = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nhanXetController,
                decoration: InputDecoration(labelText: 'Nhận xét'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nhận xét';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final dbHelper = QLQuanAnDatabaseHelper.instance;
                      final maDanhGia = await dbHelper.generateReviewId();
                      await dbHelper.insertReview({
                        'ma_danh_gia': maDanhGia,
                        'ma_khach_hang': currentUser.maLienQuan,
                        'ma_mon': widget.maMon,
                        'danh_gia': _danhGia,
                        'nhan_xet': _nhanXetController.text,
                        'ngay_danh_gia': DateTime.now().toIso8601String(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đánh giá đã được gửi thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Gửi Đánh Giá',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6790),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
