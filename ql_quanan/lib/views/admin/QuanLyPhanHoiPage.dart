// views/QuanLyPhanHoiPage.dart
import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';
import '../../models/KhachHang.dart';

class QuanLyPhanHoiPage extends StatefulWidget {
  @override
  _QuanLyPhanHoiPageState createState() => _QuanLyPhanHoiPageState();
}

class _QuanLyPhanHoiPageState extends State<QuanLyPhanHoiPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    _reviews = await _dbHelper.getAllReviews();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Phản Hồi', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _reviews.isEmpty
              ? Center(child: Text('Chưa có phản hồi nào.'))
              : ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: _dbHelper.getKhachHangByMa(review['ma_khach_hang']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox.shrink();
                      final khachHang = KhachHang.fromMap(snapshot.data!);
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/HinhAnh/KhachHang/${khachHang.hinhAnh ?? 'hinh1.jpg'}',
                            ),
                          ),
                          title: Text(khachHang.tenKhachHang ?? ''),
                          subtitle: Text(review['nhan_xet'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < review['danh_gia']
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                              ),
                            ),
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
