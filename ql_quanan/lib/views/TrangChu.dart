// views/TrangChu.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../controllers/MonAnController.dart';
import '../controllers/CartController.dart';
import '../models/MonAn.dart';
import 'DanhSachMonAn.dart';
import 'GioHang.dart';
import 'ThanhToan.dart';
import 'TheoDoiDonHang.dart';
import 'DanhGiaNhanXet.dart';
import 'ThongBaoKhuyenMai.dart';
import 'QuanLyDonHang.dart';
import 'QuanLyThucDon.dart';
import 'TheoDoiPhanHoi.dart';
import 'ThongTinCaNhan.dart';
import 'TrangLienHe.dart';
import 'auth/DangNhap.dart';
import 'admin/AdminDashboard.dart';

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
    _mostPopularFoods = await _monAnController.fetchAllMonAn();
    _mostPopularFoods.sort((a, b) => b.donGia!.compareTo(a.donGia!));
    _mostPopularFoods = _mostPopularFoods.take(5).toList();
    setState(() {
      _isLoadingPopular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.currentUser;
    final bool isAdmin = user != null && user.maVaiTro == 'QL';
    final bool isStaff = user != null && user.maVaiTro == 'NV';
    final bool isCustomer = user != null && user.maVaiTro == 'KH';
    final String avatarImagePath =
        user?.hinhAnh ?? 'assets/HinhAnh/KhachHang/default_user.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/HinhAnh/Logo.jpg'),
            ),
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
          if (isCustomer)
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
          color: Colors.pink[50],
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
                      backgroundImage: AssetImage(avatarImagePath),
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint(
                          'Lỗi tải ảnh đại diện: $avatarImagePath, Lỗi: $exception',
                        );
                      },
                    ),
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
                  Navigator.pop(context);
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
              if (isCustomer) ...[
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Color(0xFFE91E63)),
                  title: Text(
                    'Giỏ Hàng',
                    style: TextStyle(color: Colors.pink[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GioHang()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Color(0xFFE91E63)),
                  title: Text(
                    'Theo Dõi Đơn Hàng',
                    style: TextStyle(color: Colors.pink[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TheoDoiDonHang()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star, color: Color(0xFFE91E63)),
                  title: Text(
                    'Đánh Giá và Nhận Xét',
                    style: TextStyle(color: Colors.pink[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DanhGiaNhanXet()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Color(0xFFE91E63)),
                  title: Text(
                    'Thông Báo Khuyến Mãi',
                    style: TextStyle(color: Colors.pink[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThongBaoKhuyenMai(),
                      ),
                    );
                  },
                ),
              ],
              if (isStaff || isAdmin) ...[
                Divider(color: Colors.pink[200]),
                ListTile(
                  leading: Icon(Icons.list_alt, color: Colors.deepPurple),
                  title: Text(
                    'Quản Lý Đơn Hàng',
                    style: TextStyle(color: Colors.deepPurple[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuanLyDonHang()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback, color: Colors.deepPurple),
                  title: Text(
                    'Theo Dõi Phản Hồi',
                    style: TextStyle(color: Colors.deepPurple[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TheoDoiPhanHoi()),
                    );
                  },
                ),
              ],
              if (isAdmin) ...[
                ListTile(
                  leading: Icon(Icons.restaurant, color: Colors.deepPurple),
                  title: Text(
                    'Quản Lý Thực Đơn',
                    style: TextStyle(color: Colors.deepPurple[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuanLyThucDon()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.admin_panel_settings,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    'Bảng Điều Khiển Quản Lý',
                    style: TextStyle(
                      color: Colors.deepPurple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboard()),
                    );
                  },
                ),
              ],
              Divider(color: Colors.pink[200]),
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
                        ],
                      ),
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
                    backgroundColor: Color(0xFFFF6790),
                    foregroundColor: Colors.white,
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
