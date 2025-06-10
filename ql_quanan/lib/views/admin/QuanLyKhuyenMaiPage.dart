// views/admin/QuanLyKhuyenMaiPage.dart
import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';

class QuanLyKhuyenMaiPage extends StatefulWidget {
  @override
  _QuanLyKhuyenMaiPageState createState() => _QuanLyKhuyenMaiPageState();
}

class _QuanLyKhuyenMaiPageState extends State<QuanLyKhuyenMaiPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _promotions = [];
  List<Map<String, dynamic>> _filteredPromotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromotions();
    _searchController.addListener(_filterPromotions);
  }

  Future<void> _loadPromotions() async {
    setState(() => _isLoading = true);
    _promotions = await _dbHelper.getAllPromotions();
    _filteredPromotions = _promotions;
    setState(() => _isLoading = false);
  }

  void _filterPromotions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPromotions =
          _promotions
              .where((promo) => promo['tieu_de'].toLowerCase().contains(query))
              .toList();
    });
  }

  Future<void> _showAddEditDialog({Map<String, dynamic>? promotion}) async {
    final TextEditingController titleController = TextEditingController(
      text: promotion?['tieu_de'],
    );
    final TextEditingController contentController = TextEditingController(
      text: promotion?['noi_dung'],
    );
    final TextEditingController startDateController = TextEditingController(
      text: promotion?['ngay_bat_dau'],
    );
    final TextEditingController endDateController = TextEditingController(
      text: promotion?['ngay_ket_thuc'],
    );
    final TextEditingController discountController = TextEditingController(
      text: promotion?['gia_tri_giam']?.toString(),
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              promotion == null ? 'Thêm khuyến mãi' : 'Sửa khuyến mãi',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: 'Nội dung',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày bắt đầu',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'Ngày kết thúc',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Giá trị giảm (%)',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: Color(0xFFE91E63))),
              ),
              TextButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      startDateController.text.isEmpty ||
                      discountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin.'),
                      ),
                    );
                    return;
                  }
                  final newPromo = {
                    'ma_khuyen_mai':
                        promotion?['ma_khuyen_mai'] ??
                        await _dbHelper.generatePromotionId(),
                    'tieu_de': titleController.text,
                    'noi_dung': contentController.text,
                    'ngay_bat_dau': startDateController.text,
                    'ngay_ket_thuc': endDateController.text,
                    'gia_tri_giam': double.parse(discountController.text),
                  };
                  if (promotion == null) {
                    await _dbHelper.insertPromotion(newPromo);
                  } else {
                    await _dbHelper.updatePromotion(newPromo);
                  }
                  _loadPromotions();
                  Navigator.pop(context);
                },
                child: Text('Lưu', style: TextStyle(color: Color(0xFFE91E63))),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý khuyến mãi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _filteredPromotions.length,
                itemBuilder: (context, index) {
                  final promo = _filteredPromotions[index];
                  return ListTile(
                    title: Text(promo['tieu_de']),
                    subtitle: Text(promo['noi_dung']),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showAddEditDialog(promotion: promo),
                    ),
                  );
                },
              ),
    );
  }
}
