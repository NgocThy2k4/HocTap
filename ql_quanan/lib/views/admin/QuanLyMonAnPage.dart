// views/admin/QuanLyMonAnPage.dart
import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';
import '../../models/MonAn.dart'; // Đảm bảo import đúng model

class QuanLyMonAnPage extends StatefulWidget {
  @override
  _QuanLyMonAnPageState createState() => _QuanLyMonAnPageState();
}

class _QuanLyMonAnPageState extends State<QuanLyMonAnPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  List<MonAn> _monAnList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonAn();
  }

  Future<void> _loadMonAn() async {
    setState(() {
      _isLoading = true;
    });
    // Sử dụng phương thức getAllMonAn đã có trong DatabaseHelper
    _monAnList = await _dbHelper.getAllMonAn();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Món Ăn', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _monAnList.isEmpty
              ? Center(child: Text('Không có món ăn nào.'))
              : ListView.builder(
                itemCount: _monAnList.length,
                itemBuilder: (context, index) {
                  final ma = _monAnList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/HinhAnh/MonAn/${ma.hinh ?? 'default_food.png'}',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          print(
                            'Error loading image for ${ma.hinh}: $exception',
                          );
                        },
                      ),
                      title: Text(ma.tenMon ?? 'Chưa có tên món'),
                      subtitle: Text('Giá: ${ma.donGia} VNĐ'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // TODO: Implement edit logic
                              print('Edit ${ma.maMon}');
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Xác nhận xóa'),
                                      content: Text(
                                        'Bạn có chắc muốn xóa món ăn này không?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text('Hủy'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: Text('Xóa'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                await _dbHelper.deleteMonAn(ma.maMon);
                                _loadMonAn(); // Refresh list
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Đã xóa món ăn.')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new food logic
          print('Add new MonAn');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFFB2D9),
      ),
    );
  }
}
