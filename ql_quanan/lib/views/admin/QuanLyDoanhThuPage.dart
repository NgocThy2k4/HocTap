// views/admin/QuanLyDoanhThuPage.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/DatabaseHelper.dart';
import 'dart:math';

class QuanLyDoanhThuPage extends StatefulWidget {
  @override
  _QuanLyDoanhThuPageState createState() => _QuanLyDoanhThuPageState();
}

class _QuanLyDoanhThuPageState extends State<QuanLyDoanhThuPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _hoaDonList = [];
  List<Map<String, dynamic>> _filteredHoaDonList = [];
  double _totalRevenue = 0;
  bool _isLoading = true;
  String _selectedYear = DateTime.now().year.toString();
  List<String> _availableYears = [];
  Map<String, double> _monthlyRevenue = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterHoaDon);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final db = await _dbHelper.database;
    _hoaDonList = await db.query('hoa_don');
    _filteredHoaDonList = _hoaDonList;

    // Tính tổng doanh thu
    _totalRevenue = _hoaDonList.fold(
      0,
      (sum, item) => sum + (item['tong_tien'] as num),
    );

    // Lấy danh sách năm
    _availableYears =
        _hoaDonList
            .map((hd) => DateTime.parse(hd['ngay_dat']).year.toString())
            .toSet()
            .toList()
          ..sort();

    if (_availableYears.isEmpty) {
      _availableYears.add(DateTime.now().year.toString());
    }
    if (!_availableYears.contains(_selectedYear)) {
      _selectedYear = _availableYears.last;
    }

    // Tính doanh thu theo tháng
    _monthlyRevenue = {};
    for (var hd in _hoaDonList) {
      final date = DateTime.parse(hd['ngay_dat']);
      if (date.year.toString() == _selectedYear) {
        final month = date.month.toString().padLeft(2, '0');
        _monthlyRevenue[month] =
            (_monthlyRevenue[month] ?? 0) + (hd['tong_tien'] as num);
      }
    }

    setState(() => _isLoading = false);
  }

  void _filterHoaDon() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHoaDonList =
          _hoaDonList.where((hd) {
            final maKhachHang = hd['ma_khach_hang'].toString().toLowerCase();
            return maKhachHang.contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BarChartGroupData> _getBarChartData() {
    return List.generate(12, (index) {
      final month = (index + 1).toString().padLeft(2, '0');
      final revenue = _monthlyRevenue[month] ?? 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: revenue, color: Color(0xFFE91E63), width: 15),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Doanh Thu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFFE91E63)),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tổng doanh thu
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng Doanh Thu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            Text(
                              '${_totalRevenue.toStringAsFixed(2)} VNĐ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Bộ lọc năm
                    Row(
                      children: [
                        Text(
                          'Chọn năm: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE91E63),
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedYear,
                          items:
                              _availableYears
                                  .map(
                                    (year) => DropdownMenuItem(
                                      value: year,
                                      child: Text(year),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value!;
                              _loadData();
                            });
                          },
                          style: TextStyle(color: Color(0xFFE91E63)),
                          dropdownColor: Color(0xFFFCE4EC),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Biểu đồ doanh thu
                    Text(
                      'Doanh Thu Theo Tháng ($_selectedYear)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: _getBarChartData(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt() + 1}',
                                        style: TextStyle(
                                          color: Color(0xFFE91E63),
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${(value / 1000000).toStringAsFixed(1)}M',
                                        style: TextStyle(
                                          color: Color(0xFFE91E63),
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: true),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Thanh tìm kiếm
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm theo mã khách hàng...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFE91E63),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Danh sách hóa đơn
                    Text(
                      'Danh Sách Hóa Đơn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    SizedBox(height: 10),
                    _filteredHoaDonList.isEmpty
                        ? Center(child: Text('Không có hóa đơn nào.'))
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _filteredHoaDonList.length,
                          itemBuilder: (context, index) {
                            final hoaDon = _filteredHoaDonList[index];
                            return Card(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  'Mã Hóa Đơn: ${hoaDon['ma_hoa_don']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Khách Hàng: ${hoaDon['ma_khach_hang']} - Ngày: ${hoaDon['ngay_dat']}\nTổng: ${hoaDon['tong_tien'].toStringAsFixed(2)} VNĐ',
                                ),
                                trailing: Icon(
                                  Icons.receipt,
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
    );
  }
}
