// ignore_for_file: prefer_const_constructors

import 'package:store_hive/views/components/profile/user_screen.dart';
import 'package:store_hive/views/nav-pages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:store_hive/models/cart.dart';

import 'controllers/cart_notifier.dart';
import 'controllers/category_notifier.dart';
import 'controllers/order_notifier.dart';
import 'controllers/product_notifier.dart';
import 'controllers/user_notifier.dart';
import 'models/category.dart';
import 'models/order.dart';
import 'models/product.dart';
import 'models/user.dart';
import 'services/request.dart';
import 'views/auth/login_page.dart';
import 'views/auth/signup_page.dart';
import 'views/components/notification_page.dart';
import 'views/start_page.dart';

Future main() async {
  // hive setup
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(ProductAdapter());
  final userBox = await Hive.openBox<User>("userBox");
  final cartBox = await Hive.openBox<Cart>('cartBox');
  final user = userBox.get(0);

  //retrieving information from database to provider
  var categoryResponse = await get('parent-categories');
  List<Category> categoryList = [];
  List<dynamic> categoryData = categoryResponse.data;
  for (var category in categoryData) {
    categoryList.add(Category.fromMap(category));
  }

  var productResponse = await get('products');
  List<Product> productList = [];
  List<dynamic> productData = productResponse.data;
  for (var product in productData) {
    productList.add(Product.fromMap(product));
  }

  var userResponse = await get('users');
  List<User> userList = [];
  List<dynamic> userData = userResponse.data;
  for (var user in userData) {
    userList.add(User.fromMap(user));
  }

  List<Order> orderList = [];
  if (user != null) {
    final userId = user.id;
    var orderResponse = await get('order/$userId/detail');
    List<dynamic> orderData = orderResponse.data;
    for (var order in orderData) {
      orderList.add(Order.fromMap(order));
    }
  }

  List<Product> cartProducts = [];
  if (cartBox.isNotEmpty) {
    final cart = cartBox.getAt(0);
    if (cart != null) {
      cartProducts = cart.products;
    }
  }

  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryNotifier.all(categoryList),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductNotifier.all(productList),
        ),
        ChangeNotifierProvider(
          create: (context) => UserNotifier.all(userList),
        ),
        ChangeNotifierProvider(
          create: (context) => CartNotifier.all(cartProducts),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderNotifier.all(orderList),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        "/login": (context) {
          return const LoginPage();
        },
        "/signup": (context) {
          return const SignupPage();
        },
        "/home": (context) {
          return const StartPage();
        },
        "/profile": (context) {
          return UserScreen();
        },
        "/orders": (context) {
          return OrderPage();
        },
        "/notifications": (context) {
          return NotificationPage();
        },
      },
    );
  }
}
