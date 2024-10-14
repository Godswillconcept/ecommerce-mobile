// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, depend_on_referenced_packages

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../controllers/order_notifier.dart';
import '../../models/user.dart';
import '../../services/request.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _userBox = Hive.box<User>("userBox");
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _gender;
  DateTime? _dob;
  File? _image;
  bool isObscure = true;
  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dob = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: size.height * 0.2,
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
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Image.asset('images/profile.png')
                              : null,
                        ),
                        Positioned(
                          right: -5,
                          bottom: 0,
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'camera',
                                child: Text('Camera'),
                              ),
                              PopupMenuItem(
                                value: 'gallery',
                                child: Text('Gallery'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'camera') {
                                _takePicture();
                              } else if (value == 'gallery') {
                                _selectPicture();
                              }
                            },
                            icon: CircleAvatar(child: Icon(Icons.camera_alt)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _firstNameController,
                      style: TextStyle(
                        color: Color(0xff003cc5),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2),
                        prefixIconColor: Color(0xff003cc5),
                        hintText: 'First name',
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _lastNameController,
                      style: TextStyle(
                        color: Color(0xff003cc5),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2),
                        prefixIconColor: Color(0xff003cc5),
                        hintText: 'Last name',
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
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(
                        color: Color(0xff003cc5),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        prefixIconColor: Color(0xff003cc5),
                        hintText: 'Address',
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
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
                          icon: Icon(isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(
                        color: Color(0xff003cc5),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        prefixIconColor: Color(0xff003cc5),
                        hintText: 'Phone number',
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
                    Row(
                      children: _buildGenderListTiles(),
                    ),
                    ListTile(
                      title: Text('Date of Birth'),
                      subtitle: Text(_dob == null
                          ? 'Please select a date'
                          : 'Selected Date: ${_dob.toString().substring(0, 10)}'),
                      onTap: () => _showDatePicker(context),
                      trailing: Icon(Icons.calendar_today),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _signupUser();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff003cc5),
                        ),
                      ),
                      child: Text("SignUp"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            'Already have an account, Login',
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

  List<Widget> _buildGenderListTiles() {
    return ['Male', 'Female'].map((gender) {
      return Expanded(
        child: RadioListTile(
          title: Text(gender),
          value: gender,
          groupValue: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),
      );
    }).toList();
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = File('${appDir.path}/$fileName');
    await savedImage.writeAsBytes(await imageFile.readAsBytes());
    setState(() {
      _image = savedImage;
    });
  }

  Future<void> _selectPicture() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = File('${appDir.path}/$fileName');
    await savedImage.writeAsBytes(await imageFile.readAsBytes());
    setState(() {
      _image = savedImage;
    });
  }

  void _signupUser() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();
    final gender = _gender!.trim();
    final dob = DateTime.parse(_dob!.toIso8601String());
    final user = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      address: address,
      password: password,
      phone: phone,
      gender: gender,
      dob: dob,
    );
    signupUser(user, context);
  }

  Future<void> signupUser(User user, BuildContext context) async {
    try {
      // Show a loading indicator while saving a user
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
      FormData formData = FormData.fromMap(user.toMap());
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(_image!.path)));

      final response = await post('signup', formData);
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
            title: Text('Saving Failed'),
            content: Text(
                'An error occurred while saving the user. Please try again.'),
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
