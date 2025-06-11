// views/TrangChu.dart (Đã sửa lỗi)
import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../models/MonAn.dart';
import '../models/KhachHang.dart';
import 'TrangLienHe.dart';
import 'ChiTietMonAn.dart'; // Giả định có trang chi tiết món ăn

class TrangChu extends StatefulWidget {
  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<MonAn> _monAnList = [];
  List<MonAn> _filteredMonAnList = [];
  List<Map<String, dynamic>> _promotions = [];
  List<Map<String, dynamic>> _reviews = [];
  String? _selectedLoaiMonAn;
  List<String> _loaiMonAnList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterMonAn);
  }

  Future<void> _loadData() async {
    // Load món ăn
    _monAnList = await _dbHelper.getAllMonAn2();
    _filteredMonAnList = _monAnList;

    // Load loại món ăn
    final loaiMonAnMaps = await _dbHelper.database.then(
      (db) => db.query('loai_mon_an'),
    );
    _loaiMonAnList =
        loaiMonAnMaps.map((map) => map['ten_loai'] as String).toList();

    // Load khuyến mãi
    _promotions = await _dbHelper.getAllPromotions();

    // Load đánh giá
    _reviews = await _dbHelper.getAllReviews();

    setState(() {});
  }

  void _filterMonAn() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMonAnList =
          _monAnList.where((monAn) {
            final tenMon = monAn.tenMon?.toLowerCase() ?? '';
            final matchLoai =
                _selectedLoaiMonAn == null ||
                monAn.maLoai ==
                    (_loaiMonAnList.indexOf(_selectedLoaiMonAn!) + 1)
                        .toString()
                        .padLeft(2, '0');
            return tenMon.contains(query) && matchLoai;
          }).toList();
    });
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
          'Quán Ăn Ngon',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MonAnSearchDelegate(_monAnList),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh tìm kiếm và bộ lọc
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm món ăn...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFFE91E63)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedLoaiMonAn,
                hint: Text('Chọn loại món ăn'),
                isExpanded: true,
                items:
                    _loaiMonAnList
                        .map(
                          (loai) =>
                              DropdownMenuItem(value: loai, child: Text(loai)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLoaiMonAn = value;
                    _filterMonAn();
                  });
                },
              ),
              SizedBox(height: 20),

              // Thực Đơn Nổi Bật
              Text(
                'Thực Đơn Nổi Bật',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      _filteredMonAnList.length > 5
                          ? 5
                          : _filteredMonAnList.length,
                  itemBuilder: (context, index) {
                    final monAn = _filteredMonAnList[index];
                    return GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              // SỬA LỖI 1: Truyền vào monAn.maMon thay vì biến maMon không tồn tại
                              builder:
                                  (context) =>
                                      ChiTietMonAn(maMon: monAn.maMon!),
                            ),
                          ),
                      child: Card(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/HinhAnh/MonAn/${monAn.hinh ?? 'default_food.png'}',
                              height: 120,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    monAn.tenMon ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${monAn.donGia} VNĐ',
                                    style: TextStyle(color: Color(0xFFE91E63)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Khuyến Mãi và Sự Kiện
              Text(
                'Khuyến Mãi và Sự Kiện',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: 10),
              _promotions.isEmpty
                  ? Text('Hiện không có khuyến mãi.')
                  : Column(
                    children:
                        _promotions
                            .map(
                              (promo) => Card(
                                child: ListTile(
                                  title: Text(promo['tieu_de'] ?? ''),
                                  subtitle: Text(promo['noi_dung'] ?? ''),
                                  trailing: Text(
                                    '${promo['ngay_bat_dau']} - ${promo['ngay_ket_thuc']}',
                                    style: TextStyle(color: Color(0xFFE91E63)),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
              SizedBox(height: 20),

              // Giới Thiệu Quán
              Text(
                'Giới Thiệu Quán',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Quán Ăn Ngon mang đến trải nghiệm ẩm thực tuyệt vời với các món ăn đậm chất Việt Nam, không gian ấm cúng và dịch vụ tận tâm.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Đánh Giá Khách Hàng
              Text(
                'Đánh Giá Khách Hàng',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: 10),
              _reviews.isEmpty
                  ? Text('Chưa có đánh giá nào.')
                  : Column(
                    children:
                        _reviews
                            .take(3)
                            .map(
                              (review) => FutureBuilder<Map<String, dynamic>?>(
                                future: _dbHelper.getKhachHangByMa(
                                  review['ma_khach_hang'],
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return SizedBox.shrink();
                                  final khachHang = KhachHang.fromMap(
                                    snapshot.data!,
                                  );
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage(
                                          'assets/HinhAnh/KhachHang/${khachHang.hinhAnh ?? 'hinh1.jpg'}',
                                        ),
                                      ),
                                      title: Text(
                                        khachHang.tenKhachHang ?? 'Khách Hàng',
                                      ),
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
                              ),
                            )
                            .toList(),
                  ),
              SizedBox(height: 20),

              // Thông Tin Liên Hệ
              Text(
                'Thông Tin Liên Hệ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: Icon(Icons.contact_phone, color: Color(0xFFE91E63)),
                  title: Text('Liên hệ với chúng tôi'),
                  subtitle: Text('140 Lê Trọng Tấn, SĐT: 0334909123'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrangLienHe()),
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

class MonAnSearchDelegate extends SearchDelegate {
  final List<MonAn> monAnList;

  MonAnSearchDelegate(this.monAnList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        monAnList
            .where(
              (monAn) =>
                  monAn.tenMon!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final monAn = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/HinhAnh/MonAn/${monAn.hinh ?? 'default_food.png'}',
            ),
          ),
          title: Text(monAn.tenMon ?? ''),
          subtitle: Text('${monAn.donGia} VNĐ'),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  // SỬA LỖI 2: Truyền vào monAn.maMon thay vì monAn
                  builder: (context) => ChiTietMonAn(maMon: monAn.maMon!),
                ),
              ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        monAnList
            .where(
              (monAn) =>
                  monAn.tenMon!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final monAn = suggestions[index];
        return ListTile(
          title: Text(monAn.tenMon ?? ''),
          onTap: () {
            query = monAn.tenMon ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}
