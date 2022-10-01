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
   String name;

  @HiveField(3)
   double amount;

  @HiveField(4)
   List<Pay> by;

  @HiveField(5)
   List<Pay> to;

  @HiveField(6)
   DateTime date;

  Expense(
      {required this.uuid,
      required this.tripid,
      required this.name,
      required this.amount,
      required this.by,
      required this.to,
      required this.date});
}