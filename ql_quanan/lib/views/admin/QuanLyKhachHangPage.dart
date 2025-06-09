// views/admin/QuanLyKhachHangPage.dart
import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';
import '../../models/KhachHang.dart'; // Đảm bảo import đúng model

class QuanLyKhachHangPage extends StatefulWidget {
  @override
  _QuanLyKhachHangPageState createState() => _QuanLyKhachHangPageState();
}

class _QuanLyKhachHangPageState extends State<QuanLyKhachHangPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  List<KhachHang> _khachHangList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKhachHang();
  }

  Future<void> _loadKhachHang() async {
    setState(() {
      _isLoading = true;
    });
    // Sử dụng phương thức getAllKhachHang đã thêm vào DatabaseHelper
    _khachHangList = await _dbHelper.getAllKhachHang();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Khách Hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _khachHangList.isEmpty
              ? Center(child: Text('Không có khách hàng nào.'))
              : ListView.builder(
                itemCount: _khachHangList.length,
                itemBuilder: (context, index) {
                  final kh = _khachHangList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/HinhAnh/KhachHang/${kh.hinhAnh ?? 'default_customer.png'}',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          print(
                            'Error loading image for ${kh.hinhAnh}: $exception',
                          );
                        },
                      ),
                      title: Text(kh.tenKhachHang ?? 'Chưa có tên'),
                      subtitle: Text(
                        '${kh.diaChi ?? 'Chưa có địa chỉ'} - ${kh.dienThoai ?? 'Chưa có SĐT'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // TODO: Implement edit logic (navigate to an edit page or show a dialog)
                              print('Edit ${kh.maKhachHang}');
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
                                        'Bạn có chắc muốn xóa khách hàng này không?',
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
                                await _dbHelper.deleteKhachHang(kh.maKhachHang);
                                _loadKhachHang(); // Refresh list
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Đã xóa khách hàng.')),
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
          // TODO: Implement add new customer logic (navigate to an add page or show a dialog)
          print('Add new KhachHang');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFFB2D9),
      ),
    );
  }
}
