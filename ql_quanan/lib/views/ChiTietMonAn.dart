// views/ChiTietMonAn.dart (Cập nhật)

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../controllers/MonAnController.dart';
import '../controllers/CartController.dart'; // Import CartController
import '../models/MonAn.dart';
import 'DanhSachMonAn.dart'; // Giữ MonAnCard ở đây hoặc di chuyển đến shared_widgets
import 'GioHang.dart';

class ChiTietMonAn extends StatefulWidget {
  final String maMon;

  ChiTietMonAn({required this.maMon});

  @override
  _ChiTietMonAnState createState() => _ChiTietMonAnState();
}

class _ChiTietMonAnState extends State<ChiTietMonAn>
    with TickerProviderStateMixin {
  final MonAnController _monAnController = MonAnController();
  MonAn? monAn;
  List<MonAn> monAnCungLoai = [];
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadMonAn();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _loadMonAn() async {
    setState(() {
      isLoading = true;
    });
    monAn = await _monAnController.fetchMonAnDetail(widget.maMon);

    if (monAn != null) {
      monAnCungLoai = await _monAnController.fetchMonAnCungLoai(
        monAn!.maLoai,
        widget.maMon,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );
    // Lấy CartController từ Provider
    final cartController = Provider.of<CartController>(context, listen: false);

    void _showSnackBar(BuildContext context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã thêm vào giỏ hàng thành công!',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFFFF4081),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi Tiết Món Ăn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
        backgroundColor: Color(0xFFFFB2D9),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: FadeTransition(
        opacity: _animationController,
        child:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFB2D9),
                    ),
                  ),
                )
                : monAn == null
                ? Center(
                  child: Text(
                    'Không tìm thấy món ăn',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Hero(
                                tag: 'monAnImage_${monAn!.maMon}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/HinhAnh/MonAn/${monAn!.hinh}',
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,
                                    ) {
                                      return Center(
                                        child: Text(
                                          'Không có hình ảnh',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              monAn!.tenMon,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                if (monAn!.donGiaKhuyenMai != 0.0)
                                  Text(
                                    currencyFormat.format(
                                      monAn!.donGiaKhuyenMai,
                                    ),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  )
                                else
                                  Text(
                                    currencyFormat.format(monAn!.donGia),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                SizedBox(width: 10),
                                if (monAn!.donGiaKhuyenMai != 0.0)
                                  Text(
                                    currencyFormat.format(monAn!.donGia),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                            if (monAn!.khuyenMai != null &&
                                monAn!.khuyenMai!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '🎁 Khuyến mãi: ${monAn!.khuyenMai}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.pink[800],
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 10),
                            Text(
                              'Mô tả',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              monAn!.noiDungChiTiet ?? 'Không có mô tả',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Món Ăn Cùng Loại',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 10),
                            monAnCungLoai.isNotEmpty
                                ? AnimationLimiter(
                                  child: SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: monAnCungLoai.length,
                                      itemBuilder: (context, index) {
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(
                                            milliseconds: 375,
                                          ),
                                          child: SlideAnimation(
                                            horizontalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Container(
                                                width: 180,
                                                // Truyền onAddToCart vào MonAnCard
                                                child: MonAnCard(
                                                  monAn: monAnCungLoai[index],
                                                  onAddToCart: (MonAn ma) {
                                                    cartController.addItem(ma);
                                                    _showSnackBar(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                                : Text(
                                  'Không có món ăn cùng loại.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 20,
                              child: Icon(
                                Icons.home_filled,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrangDanhSachMonAn(),
                                ),
                              );
                            },
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Thêm món ăn vào giỏ hàng
                              if (monAn != null) {
                                cartController.addItem(monAn!);
                                _showSnackBar(context);
                              }
                            },
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Thêm vào giỏ hàng',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF6790),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print('Mua ngay: ${monAn!.maMon}');
                              // TODO: Logic mua ngay (có thể điều hướng đến trang thanh toán với món này)
                            },
                            child: Text(
                              'Mua ngay',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
