import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uastpm/model/pay.dart';
import 'package:uastpm/page/location.dart';
import 'model/user.dart';
import 'package:uastpm/page/btmnavbar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:uastpm/utils/theme_utils.dart';


String boxUser = 'userBox';
String boxOrder = 'boxOrder';
String username = '';
String location = 'Asia/Jakarta';
double latitude = 0.0;
double longitude = 0.0;

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.orange,
  accentColor: Colors.blue
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.orange,
    accentColor: Colors.purple
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  Hive.registerAdapter<PayModel>(PayModelAdapter()); // Register the OrderModel adapter
  await Hive.openBox<PayModel>(boxOrder);
  await Hive.openBox<UserModel>(boxUser);
  tz.initializeTimeZones();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}
class MyApp extends StatefulWidget {

  final bool isLoggedIn;


  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeMode _themeMode = ThemeMode.system;

  void changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }
  @override
  void initState() {
    super.initState();
    _setTimeZoneThemeMode();
  }

  Future<void> _setTimeZoneThemeMode() async {
    ThemeMode themeMode = await getTimeZoneThemeMode(location);
    setState(() {
      _themeMode = themeMode;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Define custom theme colors


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS TPM',
      themeMode: _themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: widget.isLoggedIn ? BtmNavBar() : LocationPage(changeThemeMode: changeThemeMode),
    );
  }
}

