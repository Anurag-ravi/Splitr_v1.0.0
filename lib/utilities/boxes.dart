

import 'package:hive/hive.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';

class Boxes {
  static Box<Trip> getTrips() => Hive.box<Trip>('trips');
  static Box<User> getUsers(String tripId) => Hive.box<User>(tripId+"u");
  static Box<Expense> getExpenses(String tripId) => Hive.box<Expense>(tripId+"e");
  static Box<Payment> getPayments(String tripId) => Hive.box<Payment>(tripId+"p");
}