import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../model/user.dart';
import 'register.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'btmnavbar.dart';



class LoginPage extends StatefulWidget {
  final ThemeMode? themeMode;

  const LoginPage({Key? key, this.themeMode}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  late Box<UserModel> _myBox;
  late SharedPreferences _prefs;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  String _inputUsername = "";
  String _inputPassword = "";
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _openBox();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
  }


  void _openBox() async {
    await Hive.openBox<UserModel>(boxUser);
    _myBox = Hive.box<UserModel>(boxUser);
  }



  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (!_myBox.containsKey(_inputUsername)) {
        // Check if username exists during login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username')),
        );
        return;
      }


      final user = _myBox.get(_inputUsername);
      if (_inputPassword == user!.password) {
        setState(() {
          username = _inputUsername;
        });
        // Save user's session
        if(_rememberMe){
          _prefs.setBool('isLoggedIn', true);
          _prefs.setString('username', _inputUsername);
        } else {
          _prefs.remove('isLoggedIn');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BtmNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password')),
        );
      }

    }
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/images/Maps.png',
                  height: 220,
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                  onSaved: (value) => _inputUsername = value!.toLowerCase(),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter a password' : null,
                  onSaved: (value) => _inputPassword = value!,
                  obscureText: _obscureText,
                ),
                SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    // Use the theme's primary color for the button background
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ),
                // SizedBox(height: 4.0),
                CheckboxListTile(
                  title: Text("Remember me"),
                  value: _rememberMe,
                  onChanged: (newValue) {
                    setState(() {
                      _rememberMe = newValue!;
                    });
                  },
                ),

                // SizedBox(height: 5.0),
                Center(child: Text("Don't have an account?")),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Create Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

}
