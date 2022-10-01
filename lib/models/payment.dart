import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 4)
class Payment extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String tripid;

  @HiveField(2)
   String from;

  @HiveField(3)
   String to;

  @HiveField(4)
   double amount;

  @HiveField(5)
   DateTime date;

  Payment(
      {required this.uuid,
      required this.tripid,
      required this.from,
      required this.to,
      required this.amount,
      required this.date});
}