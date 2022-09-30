// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/pay.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/pages/homepage.dart';
import 'package:splitr/utilities/theme_model.dart';

import 'models/payment.dart';
import 'models/user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PayAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(PaymentAdapter());
  Hive.registerAdapter(TripAdapter());
  var trips = await Hive.openBox<Trip>('trips');
  var t = trips.values.toList().cast<Trip>();
  for(int i=0;i<t.length;i++){
    await Hive.openBox<User>(t[i].uuid + "u");
    await Hive.openBox<Expense>(t[i].uuid + "e");
    await Hive.openBox<Payment>(t[i].uuid + "p");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => ThemeModel(),
      child: Consumer(
        builder: (context,ThemeModel themenotifier,child){
          return MaterialApp(
          title: 'Clans',
          theme: ThemeData(
            fontFamily: 'Poppins',
            brightness: Brightness.light,
            primarySwatch: Colors.grey,
            primaryColor: Colors.black,
            colorScheme: ColorScheme.light(
              primary: Color(0xff7ED4CB),
              secondary: Colors.black,
              background: Color(0xfffafafa),
              error: Colors.red,
            ),
            dividerColor: Colors.black12,
            iconTheme: IconThemeData(color: Colors.black)
          ),
          darkTheme: ThemeData(
            fontFamily: 'Poppins',
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
            primaryColor: Colors.white,
            colorScheme: ColorScheme.dark(
              primary: Color(0xff7ED4CB),
              secondary: Colors.white,
              background: Color(0xff424242),
              error: Colors.red,
            ),
            dividerColor: Colors.black12,
            iconTheme: IconThemeData(color: Colors.white)
          ),
          themeMode: themenotifier.isDark ? ThemeMode.dark : ThemeMode.light, 
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
        },
      ),
    );
  }
}
