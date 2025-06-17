import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Order {
  final DateTime timestamp;
  final double totalPrice;

  Order({required this.timestamp, required this.totalPrice});

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class RevenueStatsScreen extends StatefulWidget {
  const RevenueStatsScreen({super.key});

  @override
  State<RevenueStatsScreen> createState() => _RevenueStatsScreenState();
}

class _RevenueStatsScreenState extends State<RevenueStatsScreen> {
  String viewType = 'Tháng'; // hoặc 'Quý'

  Future<List<Order>> fetchOrders() async {
    final snapshot = await FirebaseFirestore.instance.collection('Orders').get();
    return snapshot.docs.map((doc) => Order.fromMap(doc.data())).toList();
  }

  Map<String, double> groupByMonth(List<Order> orders) {
    final Map<String, double> data = {};
    for (var o in orders) {
      final key = '${o.timestamp.year}-${o.timestamp.month.toString().padLeft(2, '0')}';
      data[key] = (data[key] ?? 0) + o.totalPrice;
    }
    return data;
  }

  Map<String, double> groupByQuarter(List<Order> orders) {
    final Map<String, double> data = {};
    for (var o in orders) {
      int quarter = ((o.timestamp.month - 1) ~/ 3) + 1;
      final key = '${o.timestamp.year}-Q$quarter';
      data[key] = (data[key] ?? 0) + o.totalPrice;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📊 Thống kê doanh thu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown lựa chọn kiểu thống kê
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: viewType,
                isExpanded: true,
                underline: SizedBox(),
                borderRadius: BorderRadius.circular(12),
                items: ['Tháng', 'Quý'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('Thống kê theo $value'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    viewType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Biểu đồ doanh thu
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return Center(child: Text('Không có dữ liệu doanh thu.'));

                  final rawData = snapshot.data!;
                  final grouped = viewType == 'Tháng'
                      ? groupByMonth(rawData)
                      : groupByQuarter(rawData);

                  final chartData = grouped.entries.map((e) => _ChartData(e.key, e.value)).toList()
                    ..sort((a, b) => a.label.compareTo(b.label));

                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SfCartesianChart(
                        title: ChartTitle(text: 'Doanh thu theo $viewType'),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(labelFormat: '{value} VNĐ'),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: [
                          ColumnSeries<_ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) => data.label,
                            yValueMapper: (_ChartData data, _) => data.value,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            color: Colors.deepPurple,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final double value;

  _ChartData(this.label, this.value);
}
