import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uastpm/page/login.dart';
import '../model/user.dart';
import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late Box<UserModel> _myBox;

  final _formKey = GlobalKey<FormState>();
  String _inputUsername = "";
  String _inputPassword = "";
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box(boxUser);
  }


  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      // Check if the username is already used
      if (_myBox.containsKey(_inputUsername)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username already taken')),
        );
        return;
      }

      final user = UserModel(password: _inputPassword, );

      _myBox.put(_inputUsername, user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully')),

      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 25.0),
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
                validator: (value) =>
                value!.isEmpty ? 'Please enter a username' : null,
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
                validator: (value) =>
                value!.isEmpty ? 'Please enter a password' : null,
                onSaved: (value) => _inputPassword = value!,
                obscureText: _obscureText,
              ),
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
