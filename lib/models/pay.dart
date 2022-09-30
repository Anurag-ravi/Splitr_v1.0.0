import 'package:hive/hive.dart';

part 'pay.g.dart';

@HiveType(typeId: 2)
class Pay extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final double amount;

  Pay(
      {required this.uuid,
      required this.amount,});
}