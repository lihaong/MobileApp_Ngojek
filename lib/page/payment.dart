import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:uastpm/main.dart';
import '../model/pay.dart';
import 'package:hive/hive.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'btmnavbar.dart';

class PaymentPage extends StatefulWidget {
  final double distance;
  final double priceInRupiah;
  final double priceInUSD;

  PaymentPage({
    Key? key,
    required this.distance,
    required this.priceInRupiah,
    required this.priceInUSD,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Box<PayModel> _myBoxOrder;
  late String randomId;
  late String timeInput;
  String _selectedTimeZone = 'Asia/Jakarta';
  bool _payWithDollar = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_selectedTimeZone));
    _openBox();
  }

  String _getCurrentTimeInTimeZone(String timeZoneName) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(timeZoneName));
    return DateFormat('yyyy-MM-dd HH:mm').format(now);
  }

  void _openBox() async {
    await Hive.openBox<PayModel>(boxOrder);
    _myBoxOrder = Hive.box<PayModel>(boxOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Distance: ${widget.distance.toStringAsFixed(0)} meters',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              _payWithDollar
                  ? 'Price in USD: \$ ${widget.priceInUSD.toStringAsFixed(2)}'
                  : 'Price in Rupiah: Rp ${widget.priceInRupiah.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Payment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Bank transfer'),
              onTap: () {
                // Handle bank transfer payment
                _saveOrder();
              },
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for your order!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _payWithDollar,
                  onChanged: (value) {
                    setState(() {
                      _payWithDollar = value!;
                    });
                  },
                ),
                Text('Pay with Dollar'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _navigateToOrdersPage();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    _saveOrder();
                    _showOrderRecordedDialog();
                  },
                  child: Text('Confirm Payment'),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveOrder() {
    // Create an instance of the OrderModel and save it to the Hive box
    NumberFormat numberFormatUSD = NumberFormat('#,##0.00');
    NumberFormat numberFormatIDR = NumberFormat('#,###');

    String fixed = _payWithDollar
        ? '\$ ${numberFormatUSD.format(widget.priceInUSD)}'
        : 'Rp. ${numberFormatIDR.format(widget.priceInRupiah)}';
    final order = PayModel(
      username: username,
      totalOrder: fixed,
      timeOrder: _getCurrentTimeInTimeZone(_selectedTimeZone),
    );
    _myBoxOrder.add(order);
  }

  void _navigateToOrdersPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BtmNavBar(),
      ),
    );
  }

  void _showOrderRecordedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Recorded'),
          content: Text('Your order has been recorded.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _navigateToOrdersPage();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
