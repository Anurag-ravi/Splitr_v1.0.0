import 'package:hive/hive.dart';
import 'package:splitr/models/pay.dart';

part 'expense.g.dart';

@HiveType(typeId: 3)
class Expense extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String tripid;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final List<Pay> by;

  @HiveField(5)
  final List<Pay> to;

  @HiveField(6)
  final DateTime date;

  Expense(
      {required this.uuid,
      required this.tripid,
      required this.name,
      required this.amount,
      required this.by,
      required this.to,
      required this.date});
}