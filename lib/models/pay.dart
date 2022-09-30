import 'package:hive/hive.dart';

part 'pay.g.dart';

@HiveType(typeId: 2)
class Pay extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String expenseid;

  @HiveField(2)
  final bool isBy;

  @HiveField(3)
  final double amount;

  Pay(
      {required this.uuid,
      required this.expenseid,
      required this.isBy,
      required this.amount,});
}