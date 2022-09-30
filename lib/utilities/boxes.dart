

import 'package:hive/hive.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/pay.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';

class Boxes {
  static Box<Trip> getTrips() => Hive.box<Trip>('trips');
  static Box<User> getUsers() => Hive.box<User>("users");
  static Box<Expense> getExpenses() => Hive.box<Expense>("expenses");
  static Box<Payment> getPayments() => Hive.box<Payment>("payments");
  static Box<Pay> getPay() => Hive.box<Pay>("pays");
}
