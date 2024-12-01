import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uastpm/main.dart';
import 'package:uastpm/page/login.dart';
import '../utils/theme_utils.dart';

class LocationPage extends StatefulWidget {
  final Function(ThemeMode) changeThemeMode;
  const LocationPage({super.key, required this.changeThemeMode});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  void _setThemeMode(ThemeMode mode) {
    // Call the callback function to change the theme mode
    widget.changeThemeMode(mode);
  }
  final List<DropdownMenuItem<String>> _timeZoneMenuItems = [
    const DropdownMenuItem(
      value: 'Asia/Jakarta',
      child: Text('Jakarta',
        style:
        TextStyle(fontSize: 18.0)
      ),
    ),
    const DropdownMenuItem(
      value: 'Europe/London',
      child: Text('London',
          style:
          TextStyle(fontSize: 18.0)
      ),
    ),
    const DropdownMenuItem(
      value: 'America/Los_Angeles',
      child: Text('Los Angeles',
          style:
          TextStyle(fontSize: 18.0)
      ),
    ),
    const DropdownMenuItem(
      value: 'Europe/Berlin',
      child: Text('Berlin',
          style:
          TextStyle(fontSize: 18.0)
      ),
    ),
  ];
  String _selectedTimeZone = 'Asia/Jakarta';
  bool _isLoading = false;

  Future<void> _setTimeZoneThemeMode() async {
    ThemeMode themeMode = getTimeZoneThemeMode(location);
    _setThemeMode(themeMode);
    setState(() {
    }
    );
  }

  _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double reslatitude = location.latitude;
        double reslongitude = location.longitude;
        // Do something with the latitude and longitude coordinates
        setState(() {
          latitude = reslatitude;
          longitude = reslongitude;
        });
      } else {
        // Handle case when no locations are found for the given address
        print('No locations found for the address');
      }
    } catch (e) {
      // Handle any errors that occur during the geocoding process
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to Ngojek',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Select your location:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16.0),
              if (_isLoading) CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ) else DropdownButton(
                value: _selectedTimeZone,
                items: _timeZoneMenuItems,
                onChanged: (String? value) {
                  setState(() {
                    location = value!;
                    _getCoordinatesFromAddress(location);
                    _setTimeZoneThemeMode();
                    _isLoading = true;
                    _selectedTimeZone = value;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  });
                },
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
