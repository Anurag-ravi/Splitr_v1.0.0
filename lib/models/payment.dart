import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 4)
class Payment extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String from;

  @HiveField(2)
  final String to;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime date;

  Payment(
      {required this.uuid,
      required this.from,
      required this.to,
      required this.amount,
      required this.date});
}