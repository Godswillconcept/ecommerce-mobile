// ignore_for_file: prefer_const_literals_to_create_immutables, library_private_types_in_public_api, prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:ecommerce/models/login.dart';
import 'package:ecommerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_notifier.dart';
import '../../services/request.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userBox = Hive.box<User>("userBox");
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: size.height * 0.4,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0b63f6),
                    Color(0xff003cc5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Login to continue',
                        style: TextStyle(
                          color: Color(0xff003cc5),
                          fontFamily: 'verdana',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Email address',
                      style: TextStyle(
                        color: Color(0xff003cc5),
                        fontFamily: 'verdana',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(
                        color: Color(0xff003cc5),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconColor: Color(0xff003cc5),
                        hintText: 'Your Email',
                        hintStyle: TextStyle(
                          color: Color(0xff003cc5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff003cc5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff003cc5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff003cc5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xff003cc5),
                        fontFamily: 'verdana',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      onEditingComplete: () => _loginUser(),
                      style: TextStyle(
                        color: Color(0xff003cc5),
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.security_outlined),
                        prefixIconColor: Color(0xff003cc5),
                        hintText: 'Your Password',
                        hintStyle: TextStyle(
                          color: Color(0xff003cc5),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        suffixIconColor: Color(0xff003cc5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff003cc5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff003cc5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff003cc5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        _loginUser();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff003cc5),
                        ),
                      ),
                      child: Text("Login"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xff003cc5),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              color: Color(0xff003cc5),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginUser() {
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();
    final login = Login(email: email, password: password);
    loginUser(login, context);
  }

  Future<void> loginUser(Login login, BuildContext context) async {
    try {
      // Show a loading indicator while saving a supply
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      //request to the server
      final response = await post('login', login.toMap());
      if (response.data['success'] != null) {
        _userBox.add(User.fromMap(response.data['success']));
        final userId = _userBox.values.elementAt(0).id;
        final orderNotifier =
            Provider.of<OrderNotifier>(context, listen: false);
        orderNotifier.fetchData("$userId");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(
                'The login credentials provided do not match our records. Please verify your information and try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or server error
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred. Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
