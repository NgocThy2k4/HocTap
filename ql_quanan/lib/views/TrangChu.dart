// views/TrangChu.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Thêm dependency này vào pubspec.yaml
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../controllers/MonAnController.dart'; // Để lấy món ăn phổ biến
import '../controllers/CartController.dart'; // Để quản lý giỏ hàng
import '../models/MonAn.dart'; // Để hiển thị món ăn
import 'DanhSachMonAn.dart';
import 'GioHang.dart';
import 'ThongTinCaNhan.dart'; // Mới
import 'TrangLienHe.dart'; // Mới
import 'auth/DangNhap.dart';

class TrangChu extends StatefulWidget {
  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final MonAnController _monAnController = MonAnController();
  List<MonAn> _mostPopularFoods = [];
  bool _isLoadingPopular = true;

  @override
  void initState() {
    super.initState();
    _loadPopularFoods();
  }

  Future<void> _loadPopularFoods() async {
    setState(() {
      _isLoadingPopular = true;
    });
    // Giả lập lấy món ăn phổ biến (ví dụ: các món có trong nhiều hóa đơn nhất)
    // Trong thực tế bạn cần query SQL phức tạp hơn để lấy top sản phẩm bán chạy
    _mostPopularFoods = await _monAnController.fetchAllMonAn();
    // Sắp xếp tạm thời để có vài món hiển thị, bạn cần logic từ DB
    _mostPopularFoods.sort(
      (a, b) => b.donGia!.compareTo(a.donGia!),
    ); // Sắp xếp theo giá giảm dần để có vài món khác nhau
    _mostPopularFoods =
        _mostPopularFoods.take(5).toList(); // Lấy 5 món đầu tiên
    setState(() {
      _isLoadingPopular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Ví dụ code mới dùng CircleAvatar
            CircleAvatar(
              radius:
                  20, // Bán kính 75 sẽ tạo ra đường kính 150 (tương đương width/height cũ)
              backgroundImage: AssetImage('assets/HinhAnh/Logo.jpg'),
            ),
            // Image.asset(
            //   'assets/HinhAnh/Logo.jpg',
            //   height: 40,
            // ), // Logo nhỏ trên AppBar
            SizedBox(width: 10),
            Text(
              'Quán Ăn Ngon',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GioHang()),
                  );
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Consumer<CartController>(
                  builder: (context, cart, child) {
                    return Visibility(
                      visible: cart.totalItems > 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCE4EC),
      drawer: Drawer(
        child: Container(
          color: Colors.pink[50], // Nền Drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFFFB2D9)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'assets/HinhAnh/KhachHang/hinh1.jpg',
                      ), // Ảnh tạm cho người dùng
                      // TODO: Thay bằng ảnh người dùng thực tế từ DB
                    ),
                    // SizedBox(height: 10),
                    Text(
                      user?.tenDangNhap ?? 'Khách',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? 'Chưa đăng nhập',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Color(0xFFE91E63)),
                title: Text(
                  'Trang Chủ',
                  style: TextStyle(color: Colors.pink[800]),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Already on TrangChu, do nothing or refresh
                },
              ),
              ListTile(
                leading: Icon(Icons.restaurant_menu, color: Color(0xFFE91E63)),
                title: Text(
                  'Thực Đơn',
                  style: TextStyle(color: Colors.pink[800]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrangDanhSachMonAn(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail, color: Color(0xFFE91E63)),
                title: Text(
                  'Liên Hệ',
                  style: TextStyle(color: Colors.pink[800]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrangLienHe()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Color(0xFFE91E63)),
                title: Text(
                  'Thông tin cá nhân',
                  style: TextStyle(color: Colors.pink[800]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThongTinCaNhan()),
                  );
                },
              ),
              Divider(color: Colors.pink[200]),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Đăng Xuất', style: TextStyle(color: Colors.red)),
                onTap: () {
                  authController.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => DangNhap()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Món Ăn Phổ Biến Nhất',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
            ),
            _isLoadingPopular
                ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFB2D9),
                    ),
                  ),
                )
                : _mostPopularFoods.isEmpty
                ? Center(
                  child: Text('Không có món ăn phổ biến nào để hiển thị.'),
                )
                : CarouselSlider.builder(
                  itemCount: _mostPopularFoods.length,
                  itemBuilder: (
                    BuildContext context,
                    int itemIndex,
                    int pageViewIndex,
                  ) {
                    final monAn = _mostPopularFoods[itemIndex];
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.asset(
                                    'assets/HinhAnh/MonAn/${monAn.hinh}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Center(child: Text('No Image')),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  monAn.tenMon,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Có thể thêm giá hoặc mô tả ngắn
                            ],
                          ),
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Thực Đơn Đa Dạng',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Nút "Xem Thực Đơn" hoặc một phần nhỏ của danh sách món ăn
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrangDanhSachMonAn(),
                      ),
                    );
                  },
                  icon: Icon(Icons.menu_book),
                  label: Text('Xem Toàn Bộ Thực Đơn'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
