import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';
import '../../models/NhanVien.dart';

class QuanLyNhanVienPage extends StatefulWidget {
  @override
  _QuanLyNhanVienPageState createState() => _QuanLyNhanVienPageState();
}

class _QuanLyNhanVienPageState extends State<QuanLyNhanVienPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  List<NhanVien> _nhanVienList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNhanVien();
  }

  Future<void> _loadNhanVien() async {
    setState(() {
      _isLoading = true;
    });
    _nhanVienList = await _dbHelper.getAllNhanVien();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Nhân Viên', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _nhanVienList.isEmpty
              ? Center(child: Text('Không có nhân viên nào.'))
              : ListView.builder(
                itemCount: _nhanVienList.length,
                itemBuilder: (context, index) {
                  final nv = _nhanVienList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/HinhAnh/NhanVien/${nv.hinhAnh ?? 'default_employee.png'}',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Xử lý lỗi khi không load được ảnh
                          print(
                            'Error loading image for ${nv.hinhAnh}: $exception',
                          );
                        },
                      ),
                      title: Text(nv.tenNhanVien ?? 'Chưa có tên'),
                      subtitle: Text(
                        '${nv.chucVu ?? 'Chưa có chức vụ'} - ${nv.dienThoai ?? 'Chưa có SĐT'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // TODO: Implement edit logic (show a dialog or navigate to a new page)
                              print('Edit ${nv.maNhanVien}');
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
                                        'Bạn có chắc muốn xóa nhân viên này không?',
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
                                await _dbHelper.deleteNhanVien(nv.maNhanVien);
                                _loadNhanVien(); // Refresh list
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Đã xóa nhân viên.')),
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
          // TODO: Implement add new employee logic (show a dialog or navigate to a new page)
          print('Add new NhanVien');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFFB2D9),
      ),
    );
  }
}
