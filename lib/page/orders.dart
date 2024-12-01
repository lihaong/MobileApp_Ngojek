import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/pay.dart';
import 'package:uastpm/main.dart';

class OrdersPage extends StatefulWidget {

  const OrdersPage({Key? key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Box<PayModel> _myBoxOrder;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    await Hive.openBox<PayModel>(boxOrder);
    _myBoxOrder = Hive.box<PayModel>(boxOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Detail'),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _openBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ValueListenableBuilder<Box<PayModel>>(
              valueListenable: _myBoxOrder.listenable(),
              builder: (context, box, _) {
                // Get all orders for the specified username
                List<PayModel> userOrders = box.values
                    .where((order) => order.username == username)
                    .toList();

                if (userOrders.isEmpty) {
                  return Center(
                    child: Text('No orders found for ${username}.'),
                  );
                }

                return ListView.builder(
                  itemCount: userOrders.length,
                  itemBuilder: (context, index) {
                    PayModel order = userOrders[index];
                    return ListTile(
                      title: Text('Order Number: ${(index + 1)}'), // Incrementing order ID
                      subtitle: Text('Time Order: ${order.timeOrder}'),
                      trailing: Text('Total: ${order.totalOrder}', style: TextStyle(fontSize:16, fontWeight: FontWeight.bold),),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
