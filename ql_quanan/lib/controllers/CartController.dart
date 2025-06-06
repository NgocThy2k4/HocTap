// controllers/CartController.dart (CẬP NHẬT)

import 'package:flutter/material.dart';
import '../models/MonAn.dart';
import '../models/CartItem.dart';
import '../models/User.dart'; // Import User model

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];
  User? _currentUser; // Thêm biến để giữ thông tin người dùng

  List<CartItem> get items => List.unmodifiable(_items);

  // Phương thức để cập nhật thông tin người dùng khi đăng nhập/đăng xuất
  void updateCurrentUser(User? user) {
    _currentUser = user;
    // Khi người dùng thay đổi, bạn có thể muốn tải giỏ hàng riêng của họ từ DB
    // Hoặc xóa giỏ hàng nếu người dùng đăng xuất
    if (user == null) {
      _items.clear(); // Xóa giỏ hàng khi đăng xuất
    }
    // TODO: Nếu bạn muốn lưu giỏ hàng vào DB cho mỗi người dùng,
    // thì ở đây bạn sẽ tải giỏ hàng của _currentUser từ DB.
    notifyListeners();
  }

  // Thêm món ăn vào giỏ hàng
  void addItem(MonAn monAn) {
    // Logic thêm/tăng số lượng
    int existingIndex = _items.indexWhere(
      (item) => item.monAn.maMon == monAn.maMon,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(monAn: monAn));
    }
    notifyListeners();
  }

  // Tăng số lượng của một món ăn trong giỏ hàng
  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  // Giảm số lượng của một món ăn trong giỏ hàng
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      // Logic hỏi xóa sẽ ở View
    }
    notifyListeners();
  }

  // Xóa một món ăn khỏi giỏ hàng
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Xóa tất cả món ăn khỏi giỏ hàng
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Tính tổng số tiền của giỏ hàng
  double getTotalPrice() {
    return _items.fold(0.0, (total, current) => total + current.totalPrice);
  }

  // Lấy tổng số lượng món (items) trong giỏ (không phải tổng số lượng sản phẩm)
  int get totalItems => _items.length;
}
