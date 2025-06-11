// controllers/CartController.dart (CẬP NHẬT)

import 'package:flutter/material.dart';
import '../models/MonAn.dart';
import '../models/CartItem.dart';
import '../models/User.dart'; // Import User model
import '../database/DatabaseHelper.dart';
import 'package:provider/provider.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _items = []; // <-- BỎ TỪ KHÓA 'final' Ở ĐÂY
  User? _currentUser; // Thêm biến để giữ thông tin người dùng

  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  List<CartItem> get items => List.unmodifiable(_items);

  // Cập nhật người dùng và tải giỏ hàng từ DB
  Future<void> updateCurrentUser(User? user) async {
    _currentUser = user;
    _items.clear();
    if (_currentUser != null && _currentUser!.maVaiTro == 'KH') {
      await _loadCartFromDB();
    }
    notifyListeners();
  }

  // Tải giỏ hàng từ DB dựa trên maNguoiDung
  Future<void> _loadCartFromDB() async {
    if (_currentUser == null) return;
    final db = await _dbHelper.database;
    final cartItemsFromDb = await db.query(
      // Đổi tên biến để tránh nhầm lẫn
      'cart',
      where: 'ma_nguoi_dung = ?',
      whereArgs: [_currentUser!.maNguoiDung],
    );

    // Tạo một List các Future<CartItem>
    final List<Future<CartItem>> futureCartItems =
        cartItemsFromDb.map((item) async {
          final monAnMapList = await db.query(
            // monAnMapList là List<Map<String, dynamic>>
            'mon_an',
            where: 'ma_mon = ?',
            whereArgs: [item['ma_mon']],
          );

          if (monAnMapList.isNotEmpty) {
            return CartItem(
              monAn: MonAn.fromMap(monAnMapList.first),
              quantity: item['quantity'] as int,
            );
          } else {
            // Xử lý trường hợp không tìm thấy MonAn (có thể log lỗi hoặc trả về một CartItem rỗng/mặc định)
            debugPrint('Không tìm thấy món ăn với mã: ${item['ma_mon']}');
            // Có thể trả về một CartItem với MonAn rỗng hoặc null, tùy vào logic của bạn
            return CartItem(
              monAn: MonAn(
                maMon: '',
                tenMon: 'Unknown',
                donGia: 0.0,
                maLoai: '', // <-- THÊM DÒNG NÀY VÀO
              ),
              quantity: 0,
            ); // Ví dụ: trả về CartItem rỗng
          }
        }).toList();

    // Chờ tất cả các Future hoàn thành
    _items = await Future.wait(
      futureCartItems,
    ); // <-- SỬ DỤNG AWAIT FUTURE.WAIT() Ở ĐÂY

    notifyListeners();
  }

  // Lưu giỏ hàng vào DB
  Future<void> _saveCartToDB() async {
    if (_currentUser == null || _currentUser!.maVaiTro != 'KH') return;
    final db = await _dbHelper.database;
    await db.delete(
      'cart',
      where: 'ma_nguoi_dung = ?',
      whereArgs: [_currentUser!.maNguoiDung],
    );
    for (var item in _items) {
      await db.insert('cart', {
        'ma_nguoi_dung': _currentUser!.maNguoiDung,
        'ma_mon': item.monAn.maMon,
        'quantity': item.quantity,
      });
    }
  }

  // // Phương thức để cập nhật thông tin người dùng khi đăng nhập/đăng xuất
  // void updateCurrentUser(User? user) {
  //   _currentUser = user;
  //   // Khi người dùng thay đổi, bạn có thể muốn tải giỏ hàng riêng của họ từ DB
  //   // Hoặc xóa giỏ hàng nếu người dùng đăng xuất
  //   if (user == null) {
  //     _items.clear(); // Xóa giỏ hàng khi đăng xuất
  //   }
  //   // TODO: Nếu bạn muốn lưu giỏ hàng vào DB cho mỗi người dùng,
  //   // thì ở đây bạn sẽ tải giỏ hàng của _currentUser từ DB.
  //   notifyListeners();
  // }

  // Thêm món ăn vào giỏ hàng
  void addItem(MonAn monAn) {
    if (_currentUser == null || _currentUser!.maVaiTro != 'KH') return;
    int existingIndex = _items.indexWhere(
      (item) => item.monAn.maMon == monAn.maMon,
    );
    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(monAn: monAn));
    }
    _saveCartToDB();
    notifyListeners();
  }

  // Tăng số lượng
  void increaseQuantity(CartItem item) {
    item.quantity++;
    _saveCartToDB();
    notifyListeners();
  }

  // Giảm số lượng
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      _saveCartToDB();
    }
    notifyListeners();
  }

  // Xóa món ăn
  void removeItem(CartItem item) {
    _items.remove(item);
    _saveCartToDB();
    notifyListeners();
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    _items.clear();
    _saveCartToDB();
    notifyListeners();
  }

  // Tính tổng tiền
  double getTotalPrice() {
    return _items.fold(0.0, (total, current) => total + current.totalPrice);
  }

  // Tổng số món
  int get totalItems => _items.length;
}
