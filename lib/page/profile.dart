import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../model/pay.dart';
import '../model/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Box<UserModel> _myBox;
  late Box<PayModel> _myBoxOrder;

  @override
  void initState() {
    super.initState();
    _openBox();
    _myBox = Hive.box(boxUser);
    _myBoxOrder = Hive.box(boxOrder);
  }

  void _openBox() async {
    await Hive.openBox<UserModel>(boxUser);
    _myBox = Hive.box<UserModel>(boxUser);
    await Hive.openBox<PayModel>(boxOrder);
    _myBoxOrder = Hive.box<PayModel>(boxOrder);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _myBox.close();
              _myBoxOrder.close();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp(isLoggedIn: false)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/fajar.jpg'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Muhammad Fajar Andikha',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Kelas : IF - A',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'NIM : 123200054',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            ListTile(
              leading: Icon(Icons.menu_open_rounded),
              title: Text('Detail'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                showDetail(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('Kesan'),
              trailing: Text('Mengasyikkan mempelajari flutter.'),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Pesan'),
              trailing: Text('Semangat Teman'),
            ),
          ],
        );
      },
    );
  }
}
