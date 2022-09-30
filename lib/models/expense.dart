import 'package:hive/hive.dart';
import 'package:splitr/models/pay.dart';

part 'expense.g.dart';

@HiveType(typeId: 3)
class Expense extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final List<Pay> by;

  @HiveField(4)
  final List<Pay> to;

  @HiveField(5)
  final DateTime date;

  Expense(
      {required this.uuid,
      required this.name,
      required this.amount,
      required this.by,
      required this.to,
      required this.date});
}